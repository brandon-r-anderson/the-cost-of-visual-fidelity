USE game_performance;

SET SQL_SAFE_UPDATES = 0; 
-- remove extra spaces
UPDATE stg_benchmark
SET
	game = TRIM(game),
    hdr = TRIM(hdr),
    scene_type = TRIM(scene_type),
    preset = TRIM(preset);

-- remove excess whitespace
UPDATE stg_benchmark
SET
    game = REPLACE(REPLACE(REPLACE(game, '\t', ''), '\n', ''), '\r', ''),
    hdr = REPLACE(REPLACE(REPLACE(hdr, '\t', ''), '\n', ''), '\r', ''),
    scene_type = REPLACE(REPLACE(REPLACE(scene_type, '\t', ''), '\n', ''), '\r', ''),
    preset = REPLACE(REPLACE(REPLACE(preset, '\t', ''), '\n', ''), '\r', '');

-- identify null values
SELECT *
FROM stg_benchmark
WHERE game IS NULL
	OR hdr IS NULL
    OR scene_type IS NULL
    OR preset IS NULL
    OR run IS NULL
    OR avg_cpu_usage IS NULL
    OR avg_cpu_package IS NULL
    OR avg_gpu_temp IS NULL
    OR avg_gpu_load IS NULL
    OR avg_fps IS NULL
    OR avg_1percent_low_fps IS NULL
    OR avg_1percent_high_frame_time IS NULL;

-- identify duplicate rows
SELECT
    game,
    hdr,
    preset,
    scene_type,
    avg_fps,
    avg_gpu_temp,
    COUNT(*) AS duplicate_count
FROM stg_benchmark
GROUP BY
    game,
    hdr,
    preset,
    scene_type,
    avg_fps,
    avg_gpu_temp
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

-- validate numeric values
SELECT *
FROM stg_benchmark
WHERE run < 0 OR run > 2
	OR avg_cpu_usage < 0 OR avg_cpu_usage > 100
    OR avg_cpu_package < 20 OR avg_cpu_package > 100
    OR avg_gpu_temp < 20 OR avg_gpu_temp > 100
    OR avg_gpu_load < 0 OR avg_gpu_load > 100
    OR avg_fps < 0 OR avg_fps > 300
    OR avg_1percent_low_fps < 0 OR avg_1percent_low_fps > 300
    OR avg_1percent_high_frame_time < 0 OR avg_1percent_high_frame_time > 300;
    
    SET SQL_SAFE_UPDATES = 1;
