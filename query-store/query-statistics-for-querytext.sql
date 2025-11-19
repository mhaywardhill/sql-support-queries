SELECT
	i.[start_time]
,	i.[end_time]
,	q.[query_id]
,	q.[query_hash]
,	qt.[query_sql_text]
,	CAST(pl.[query_plan] as XML) as "queryplan"
,	pl.[plan_id]
,	pl.[query_plan_hash]
,	s.[max_duration]/1000.0 AS "max_duration_ms"
,	s.[avg_duration]/1000.0 AS "avg_duration_ms"
,	s.[min_duration]/1000.0 AS "min_duration_ms"
,	s.[max_cpu_time]
,	s.[avg_cpu_time]
,	s.[min_cpu_time]
,	s.[avg_logical_io_reads]
,	(s.[avg_logical_io_reads]*8)/1024.0 AS "avg_logical_io_reads_MB"
,	s.[count_executions]
,	s.[execution_type]
,	s.[execution_type_desc]
FROM 
	sys.query_store_query q
JOIN
	sys.query_store_query_text qt ON q.[query_text_id] = qt.[query_text_id]
JOIN
	sys.query_store_plan pl ON (q.[query_id] = pl.[query_id])
JOIN 
	sys.query_store_runtime_stats s ON (s.[plan_id] = pl.[plan_id])
JOIN
	sys.query_store_runtime_stats_interval i ON (s.[runtime_stats_interval_id] = i.[runtime_stats_interval_id])
WHERE 
	qt.[query_sql_text] like '%posts%'
AND
	i.[start_time] > '20251119 07:00' 
AND
	i.[start_time] < '20251119 23:59' 
ORDER BY
	i.[start_time] DESC;