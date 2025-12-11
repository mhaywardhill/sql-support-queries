/*
Run in master database
Reads server-level audit files from the master folder and outputs per‑day activity metrics including the maximum statement length
*/

DECLARE @StoragePath    NVARCHAR(4000) = N'https://<storage account name>.blob.core.windows.net/sqldbauditlogs/<server name>/master/SqlDbAuditing_ServerAudit_NoRetention/';
DECLARE @StartUtc       NVARCHAR(30)   = N'2025-11-19T00:40:40Z';
DECLARE @EndUtc         NVARCHAR(30)   = N'2025-11-19T19:10:40Z';

WITH AuditData AS
(
    SELECT 
        [event_time]
      , [database_name]
      , LEN(ISNULL([statement], '')) AS statement_length
    FROM sys.fn_get_audit_file_v2(
        @StoragePath,
        DEFAULT,    
        DEFAULT,    
        @StartUtc,
        @EndUtc
    ) 
    WHERE [database_name] <> ''
)
SELECT 
      database_name
    , CAST([event_time] AS date) AS "event_date"
    , COUNT(*) AS "total_events"
    , MAX([statement_length]) AS "max_statement_length"
FROM AuditData
GROUP BY 
      [database_name],
      CAST([event_time] AS "date")
ORDER BY 
      [event_date],
      [database_name];
