SELECT 
    TABLE_SCHEMA,
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
ORDER BY TABLE_SCHEMA, TABLE_NAME, ORDINAL_POSITION;


USE Movies;
GO

SELECT
    s.Studio            AS [Tên Studio sản xuất],
    g.Genre             AS [Thể loại phim],
    d.FullName          AS [Tên giám đốc sản xuất],
    f.Title             AS [Tên bộ phim],
    f.BudgetDollars     AS [Kinh phí sản xuất ($)],
    CASE
        WHEN f.RunTimeMinutes < 60 THEN 'Less than 1 hour'
        WHEN f.RunTimeMinutes <= 120 THEN '1 hour - 2 hours'
        ELSE 'More than 2 hours'
    END                 AS [Thời lượng bộ phim]
FROM dbo.Film AS f
JOIN dbo.Studio   AS s ON s.StudioID   = f.StudioID
JOIN dbo.Genre    AS g ON g.GenreID    = f.GenreID
JOIN dbo.Director AS d ON d.DirectorID = f.DirectorID
WHERE
    f.ReleaseDate >= '1992-01-01'
    AND f.BudgetDollars > 300000000
ORDER BY
    f.BudgetDollars DESC,
    f.ReleaseDate DESC,
    f.Title;
