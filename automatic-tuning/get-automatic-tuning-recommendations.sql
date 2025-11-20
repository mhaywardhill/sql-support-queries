SELECT
             [type],
             [CID].[IndexName], 
             [CID].[Schema], 
             [CID].[Table], 
             [CID].[KeyColumns], 
             [CID].[IncludedColumns],
             [CID].[IndexType],
             [valid_since], 
             [execute_action_start_time], 
             [execute_action_duration], 
             [execute_action_initiated_by],
             [revert_action_start_time], 
             [revert_action_duration], 
             [revert_action_initiated_by],
             [IS].[IndexSize],
             [IS].[SizeUnit],
             JSON_VALUE(state, '$.currentValue') [CurrentValue],
             JSON_VALUE(details, '$.implementationDetails.script') [Script],
             [score]
         FROM
             [sys].[dm_db_tuning_recommendations]
         CROSS APPLY
             OPENJSON (details, '$.createIndexDetails')
         WITH
             ( [IndexName] NVARCHAR(1000) '$.indexName',
                 [Schema] NVARCHAR(1000) '$.schema',
                 [Table] NVARCHAR(1000) '$.table',
                 [KeyColumns] NVARCHAR(1000) '$.indexColumns',
                 [IncludedColumns] NVARCHAR(1000) '$.includedColumns',
                 [IndexType] NVARCHAR(1000) '$.indexType'
                 ) AS [CID]
         CROSS APPLY
             OPENJSON (details, '$.estimatedImpact')
         WITH
             ( [IndexSize] DECIMAL(10,2) '$.absoluteValue',
                 [SizeUnit] NVARCHAR(15) '$.unit'
             ) AS [IS]