SELECT 
    table_schema AS `Database Name`,
    COUNT(table_name) AS `Total Tables`,
    SUM(table_rows) AS `Total Records`,
    ROUND(SUM(data_length + index_length) / 1024, 2) AS `Total Volume (KB)`,
    ROUND(SUM(data_length + index_length) / (1024 * 1024), 4) AS `Total Volume (MB)`
FROM information_schema.TABLES
WHERE table_schema = 'airbnb_datamart'
GROUP BY table_schema;