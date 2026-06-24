import pandas as pd
import glob
import os

# clean column headers
def normalize_columns(df):
    df.columns = (
        df.columns
        .str.strip()
        .str.lower()
        .str.replace("1% low", "1percent_low", regex=False)
        .str.replace("1% high", "1percent_high", regex=False)
        .str.replace(" ", "_", regex=False)
        .str.replace(r"\[.*?\]", "", regex=True)
        .str.replace(r"[()]", "", regex=True)
        .str.replace("°c", "", regex=False)
        .str.replace("%", "percent", regex=False)
        .str.replace("__+", "_", regex=True)
        .str.strip("_")
    )
    return df

#----------------------------------------------------------------------------------------------------------------------

# create raw dataset
dfs = []
files = glob.glob(r"C:/Users/Brandon Anderson/Desktop/HWINFO_LOGS/*.csv")

for file in files:
    name = os.path.splitext(os.path.basename(file))[0]
    parts = name.split("_")

    if len(parts) < 4:
        print(f"Skipping malformed filename: {name}")
        continue

    game = parts[0]
    hdr = parts[1]

    # account for filenames from games with built-in benchmarking tool (no "dark" or "bright" in filename)
    if len(parts) == 4:
        scene = "Benchmark"
        preset = parts[2]
        run = parts[3]

    # account for filenames from games with no built-in benchmarking tool ("dark" or "bright" in filename)
    else:
        scene = parts[2]
        preset = parts[3]
        run = parts[4]

    df = pd.read_csv(file, encoding="cp1252")

    # remove extra column added by HWINFO
    df = df.loc[:, ~df.columns.str.contains("^Unnamed", na=False)]

    if "Date" in df.columns:
        df = df.drop(columns=["Date"])

    # remove extra 2 rows added by HWINFO
    df = df.iloc[:-2]
    df = normalize_columns(df)

    df["game"] = game
    df["hdr"] = hdr
    df["scene_type"] = scene
    df["preset"] = preset
    df["run"] = int(run)

    dfs.append(df)

combined = pd.concat(dfs, ignore_index=True)
combined = normalize_columns(combined)

# remove duplicate columns
combined = combined.loc[:, ~combined.columns.duplicated()]

# convert data type to numeric
numeric_cols = [
    "total_cpu_usage",
    "cpu_package",
    "gpu_temperature",
    "gpu_core_load",
    "framerate_displayed_avg",
    "framerate_displayed_1percent_low",
    "frame_time_displayed_1percent_high"
]

for col in numeric_cols:
    if col in combined.columns:
        combined[col] = pd.to_numeric(combined[col], errors="coerce")

combined.to_csv("hwinfo_combined.csv", index=False)

# ---------------------------------------------------------------------------------------------------------------------

# create aggregated dataset
summary = combined.groupby(
    ["game", "hdr", "scene_type", "preset", "run"],
    as_index=False
).agg(
    avg_cpu_usage=("total_cpu_usage", "mean"),
    avg_cpu_package=("cpu_package", "mean"),
    avg_gpu_temp=("gpu_temperature", "mean"),
    avg_gpu_load=("gpu_core_load", "mean"),
    avg_fps=("framerate_displayed_avg", "mean"),
    avg_1percent_low_fps=("framerate_displayed_1percent_low", "mean"),
    avg_1percent_high_frame_time=("frame_time_displayed_1percent_high", "mean")
)

summary.to_csv("benchmark_summary.csv", index=False)

# create staging fact table in mysql
import pandas as pd
from sqlalchemy import create_engine

df = pd.read_csv("benchmark_summary.csv")

engine = create_engine(
    "mysql+mysqlconnector://root:Scottstots12*@localhost:3306/game_performance"
)

df.to_sql("stg_benchmark", engine, if_exists="replace", index=False)