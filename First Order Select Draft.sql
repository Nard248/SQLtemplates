-- SELECT u.PartnerUserId, max(o.CalculationDate_DT) AS first_order_date
-- FROM casino.orders o INNER JOIN VIEW_PlatformPartnerUsers_TotogamingAm u ON o.UserID = u.UserID
-- WHERE u.RegistrationDate >= '2022-07-01'
-- GROUP BY u.PartnerUserId
SELECT U.PartnerUserId, U.RegistrationDate, COUNT(*) AS OrderCountFirstDay, cat.CategoryName AS next_month_category
FROM VIEW_PlatformPartnerUsers_TotogamingAM U 
LEFT JOIN casino.orders O ON O.UserID = U.UserID
LEFT JOIN DIM_Date ddt ON O.CalculationDate_DT = ddt.date
INNER JOIN crm.UsersCategoriesHistory cat ON U.PartnerUserId = cat.TotoID AND CategoryMonth = DATEADD(MONTH, 1, ddt.date)
WHERE U.RegistrationDate >= '2022-04-01'
AND O.CalculationDate_DT >= U.RegistrationDate AND O.CalculationDate_DT < DATEADD(day, 1, U.RegistrationDate)	
AND O.OrderStateID NOT IN (1, 4, 7)
AND O.OperationTypeID IN (3)
GROUP BY U.PartnerUserId, U.RegistrationDate, cat.CategoryName
ORDER BY OrderCountFirstDay 