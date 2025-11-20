SELECT 
    t.name AS TableName,
    s.name AS SchemaName,
    p.rows AS [RowCount],
    CAST((SUM(a.total_pages) * 8.0) / 1024 AS DECIMAL(18,2)) AS SizeMB
FROM sys.tables AS t
INNER JOIN sys.schemas AS s ON t.schema_id = s.schema_id
INNER JOIN sys.partitions AS p ON t.object_id = p.object_id
INNER JOIN sys.allocation_units AS a ON p.partition_id = a.container_id
WHERE t.is_ms_shipped = 0
GROUP BY t.name, s.name, p.rows
ORDER BY SizeMB DESC;
