# The Cost of Visual Fidelity

## Overview
*The Cost of Visual Fidelity* investigates the tradeoff between graphical quality and gaming performance. Using benchmark data collected from four modern PC games, this project examines how graphics presets, HDR, and scene characteristics influence framerate stability, temperatures, utilization, and power consumption.

The objective was to determine whether increasing visual fidelity introduces measurable performance instability and identify the point at which higher settings begin to negatively impact the gameplay experience.

---

## Questions Explored

- How much performance is sacrificed when increasing graphics quality?
- Does HDR introduce measurable instability?
- Are some games more tolerant of higher graphical settings than others?
- Do scene characteristics (bright vs. dark environments) influence performance?
- At what point do higher settings cease to provide meaningful visual gains relative to their performance cost?

---

## Dataset

Performance metrics were collected using **HWiNFO** while benchmarking four games:

- Black Myth: Wukong
- Cyberpunk 2077
- Kingdom Come: Deliverance II
- Resident Evil Requiem

Two games included built-in benchmarking tools, while two required manually controlling the in-game camera.

The data collection process produced **72 CSV files**, representing combinations of:

- Graphics preset (Low, Medium, High)
- HDR (On/Off)
- Scene type (Bright/Dark where applicable)
- Repeated benchmark runs

Python scripts consolidated the raw CSV exports into a single analytical dataset containing one observation per benchmark run.

---

## Tools & Technologies

| Tool | Purpose |
|------|---------|
| Python | CSV consolidation and preprocessing |
| Pandas | Data cleaning and transformation |
| MySQL | Star schema implementation and storage |
| SQL | Data transformation and analysis |
| Power BI | Dashboard creation and DAX measures |
| HWiNFO | Hardware monitoring and benchmark logging |

---

## Methodology

1. **Data Collection**
   - Captured hardware metrics with HWiNFO during benchmark sessions.

2. **Preprocessing**
   - Consolidated 72 benchmark files into a structured dataset.
   - Removed unnecessary rows and standardized column names.

3. **Database Design**
   - Designed a star schema consisting of:
     - `fact_benchmark`
     - `dim_game`
     - `dim_graphics_settings`
     - `dim_scene`
     - `dim_run`

4. **Analysis**
   - Used SQL joins, aggregations, and window functions to compare benchmark configurations.

5. **Visualization**
   - Built an interactive Power BI dashboard featuring:
     - KPI cards
     - DAX measures
     - Slicers
     - Comparative performance visualizations

---

## Key Findings

Across all four games, the highest graphics preset was often viable without introducing meaningful instability.

Some titles exhibited minor increases in frame-time variability or GPU temperatures at higher settings, but these effects were generally small relative to the gains in visual fidelity.

Notable observations include:

- **Cyberpunk 2077** showed the greatest sensitivity to higher graphical settings.
- **Kingdom Come: Deliverance II** demonstrated consistently strong performance, even with HDR enabled.
- **Resident Evil Requiem** performed better in dark scenes than bright scenes.
- **Black Myth: Wukong** maintained acceptable temperatures and smoothness metrics across nearly all configurations.

Detailed game-by-game findings and recommendations are available on my portfolio website.

---

## Repository Structure

```text
├── data/
│   ├── aggregated.csv
│   └── consolidated.csv
├── python/
│   └── main.py
├── sql/
│   ├── Create Database.sql
│   ├── Clean and Validate Staging Data.sql
│   └── Insert Data.sql
├── powerbi/
│   └── Game Graphics Project.pbix
├── assets/
│   ├── cinebench_test_results/
│   └── controller_logo.png
├── README.md
└── .gitignore
```

---

## Limitations

This analysis was conducted using a single hardware configuration, limiting the ability to generalize findings to other systems.

Additionally, manual camera movement was required for some benchmarks, introducing a potential source of variability compared to built-in benchmarking tools.

Future work could investigate topics such as:

- DLSS and FSR performance scaling
- Unreal Engine 5 optimization
- CPU-bound versus GPU-bound workloads
- Additional hardware configurations
- Larger game samples

---

## Additional Information

A more detailed discussion of the methodology, findings, and recommendations for each game can be found on my portfolio website.