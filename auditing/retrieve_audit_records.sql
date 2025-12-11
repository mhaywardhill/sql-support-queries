/*
Retrieve audit records from the master folder when auditing is configured at the server level (master/SqlDbAuditing_ServerAudit_NoRetention)
*/

DECLARE @StoragePath    NVARCHAR(4000) = N'https://<storage account name>.blob.core.windows.net/sqldbauditlogs/<server name>/master/SqlDbAuditing_ServerAudit_NoRetention/';
DECLARE @DbName         SYSNAME        = N'AdventureWorksLT';
DECLARE @StartUtc       NVARCHAR(30)   = N'2025-11-19T00:40:40Z';
DECLARE @EndUtc         NVARCHAR(30)   = N'2025-11-19T19:10:40Z';

SELECT 
    [event_time]
,   [action_id]
,   [server_instance_name]
,   [database_name]
,   [session_id]
,   [statement]
,   [additional_information]
,   [application_name]
,   [host_name]
,   [client_ip]
,   [server_principal_name]
,   [client_tls_version_name]
,   [duration_milliseconds]
,   [response_rows]
,   [affected_rows]
,   [is_local_secondary_replica]
FROM sys.fn_get_audit_file_v2(
    @StoragePath,
    DEFAULT,    
    DEFAULT,    
    @StartUtc,
    @EndUtc
) 
WHERE
    [database_name] = @DbName
