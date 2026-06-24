CREATE DATABASE IF NOT EXISTS game_performance;
USE game_performance;

CREATE TABLE IF NOT EXISTS dim_game (
	game_id INT auto_increment PRIMARY KEY,
    game_name VARCHAR(100) NOT NULL,
    benchmark_type ENUM("Built-in", "Manual") NOT NULL,
    
    CONSTRAINT uq_game
    UNIQUE (game_name, benchmark_type)
);

CREATE TABLE IF NOT EXISTS dim_graphics_settings (
	graphics_id INT auto_increment PRIMARY KEY,
    hdr ENUM("On", "Off") NOT NULL,
    preset VARCHAR(50) NOT NULL,
    
    CONSTRAINT uq_graphics_settings
    UNIQUE (hdr, preset)
);

CREATE TABLE IF NOT EXISTS dim_scene (
	scene_id INT auto_increment PRIMARY KEY,
    scene_type VARCHAR(50) NOT NULL,
    
    CONSTRAINT uq_scene
    UNIQUE (scene_type)
);

CREATE TABLE IF NOT EXISTS dim_run (
	run_id INT auto_increment PRIMARY KEY,
    run_number INT NOT NULL,
    
    CONSTRAINT uq_run
    UNIQUE (run_number)
);

CREATE TABLE IF NOT EXISTS fact_benchmark (
	benchmark_id INT NOT NULL PRIMARY KEY,
    
    game_id INT NOT NULL,
    graphics_id INT NOT NULL,
    scene_id INT NOT NULL,
    run_id INT NOT NULL,
    
    avg_cpu_usage FLOAT,
    avg_cpu_package FLOAT,
    avg_gpu_temp FLOAT,
    avg_gpu_load FLOAT,
    
    avg_fps FLOAT,
    avg_1percent_low_fps FLOAT,
    avg_1percent_high_frame_time FLOAT,
    
    FOREIGN KEY (game_id)
		REFERENCES dim_game(game_id),
        
	FOREIGN KEY (graphics_id)
		REFERENCES dim_graphics_settings(graphics_id),
        
	FOREIGN KEY (scene_id)
		REFERENCES dim_scene(scene_id),
        
	FOREIGN KEY (run_id)
		REFERENCES dim_run(run_id)
);