DROP TABLE IF EXISTS #checks

SELECT o.OrderID
INTO #checks
FROM sport.OrdersBetsStakes o
LEFT JOIN sport.CashoutHistory h ON h.OrderID = o.OrderID
WHERE o.OrderStateID IN (1,4,7)
AND h.CashoutId is NULL 
AND o.UserBonusID is NULL
AND o.TournamentID = 1
AND o.IsInternet = 1
AND o.OrderStateID = 2
AND o.OrderDate >= '2022-10-06 20:00' AND o.OrderDate <= '2022-10-26 19:59'
AND o.CalculationDate >= '2022-10-06 20:00' AND o.CalculationDate <= '2022-10-26 19:59'
GROUP BY o.OrderID

SELECT o.UserID, SUM(o.StakeAmount) AS Order_amount, EXP(SUM(LOG(o.Odds))) AS Odds, 
(SUM(o.StakeAmount)*EXP(SUM(LOG(o.Odds))) - SUM(o.StakeAmount)) * COUNT(DISTINCT(OrderDate_DT))  AS Points, 
COUNT(DISTINCT(OrderDate_DT)) --SUM(winAmount) -SUM(stake)
FROM sport.OrdersBetsStakes o
INNER JOIN #checks ON #checks.OrderID = o.OrderID
-- LEFT JOIN VIEW_PlatformPartnerUsers_TotogamingAm u ON o.UserID = u.UserID
WHERE 
    o.OrderStateID IN (1,4,7)
-- AND o.OrderDate >= '2022-10-06 20:00' AND o.OrderDate <= '2022-10-26 23:59'
-- AND o.CalculationDate >= '2022-10-06 20:00' AND o.CalculationDate <= '2022-10-26 19:59'
AND o.Odds >= 1.5
GROUP BY o.UserID, o.CheckNumber
HAVING 
    SUM(o.StakeAmount) >= 500
AND EXP(SUM(LOG(o.Odds))) >= CASE WHEN o.BetCategoryID = 3 THEN 2.5 ELSE 1.8 END