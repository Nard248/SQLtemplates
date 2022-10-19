DROP TABLE IF EXISTS #second_order

SELECT *
FROM
  ( SELECT o.CalculationDate_DT, 
        ROW_NUMBER() OVER(ORDER BY o.CalculationDate_DT DESC) AS RowNumber
    FROM casino.orders o
  ) AS tmp
WHERE RowNumber = 2 ;