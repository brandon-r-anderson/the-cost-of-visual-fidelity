INSERT IGNORE INTO dim_game (game_name)
SELECT DISTINCT
    CASE game
        WHEN 'BMW' THEN 'Black Myth Wukong'
        WHEN 'CP2077' THEN 'Cyberpunk 2077'
        WHEN 'KCD2' THEN 'Kingdom Come: Deliverance II'
        WHEN 'RE9' THEN 'Resident Evil Requiem'
    END
FROM stg_benchmark
WHERE game IN ("BMW", "CP2077", "KCD2", "RE9");

INSERT IGNORE INTO dim_graphics_settings (hdr, preset)
SELECT DISTINCT
    stg.hdr,
    stg.preset
FROM stg_benchmark stg
WHERE stg.hdr IS NOT NULL
	AND stg.preset IS NOT NULL;

INSERT IGNORE INTO dim_scene (scene_type)
SELECT DISTINCT stg.scene_type
FROM stg_benchmark stg
ON DUPLICATE KEY UPDATE scene_type = stg.scene_type;

INSERT IGNORE INTO dim_run (run_number)
SELECT DISTINCT run
FROM stg_benchmark
ON DUPLICATE KEY UPDATE run_number = run_number;

INSERT IGNORE INTO fact_benchmark (
	benchmark_id,
    game_id,
    graphics_id,
    scene_id,
    run_id,
    avg_cpu_usage,
    avg_cpu_package,
    avg_gpu_temp,
    avg_gpu_load,
    avg_fps,
    avg_1percent_low_fps,
    avg_1percent_high_frame_time
)
SELECT
	ROW_NUMBER() OVER (
		ORDER BY game_id, scene_id, graphics_id
    ) AS benchmark_id,
    g.game_id,
    gfx.graphics_id,
    s.scene_id,
    r.run_id,

    stg.avg_cpu_usage,
    stg.avg_cpu_package,
    stg.avg_gpu_temp,
    stg.avg_gpu_load,
    stg.avg_fps,
    stg.avg_1percent_low_fps,
    stg.avg_1percent_high_frame_time

FROM stg_benchmark stg
JOIN dim_game g
    ON g.game_name = CASE stg.game
        WHEN 'BMW' THEN 'Black Myth Wukong'
        WHEN 'CP2077' THEN 'Cyberpunk 2077'
        WHEN 'KCD2' THEN 'Kingdom Come: Deliverance II'
        WHEN 'RE9' THEN 'Resident Evil Requiem'
    END
JOIN dim_graphics_settings gfx
    ON gfx.hdr = stg.hdr
   AND gfx.preset = stg.preset
JOIN dim_scene s
    ON s.scene_type = stg.scene_type
JOIN dim_run r
    ON r.run_number = stg.run;