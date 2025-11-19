SELECT 
	i.[start_time]
,	i.[end_time]
,	q.[query_id]
,	p.[plan_id]
,	ws.*
FROM 
	sys.query_store_wait_stats AS ws
JOIN 
	sys.query_store_plan AS p ON ws.plan_id = p.plan_id
JOIN 
	sys.query_store_query AS q ON p.query_id = q.query_id
JOIN
	sys.query_store_runtime_stats_interval i ON (ws.[runtime_stats_interval_id] = i.[runtime_stats_interval_id])
ORDER BY
	i.[start_time] DESC;