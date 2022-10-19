DECLARE @min_order_amount INT = 500
DECLARE @each_odds FLOAT = 1.5
DECLARE @express_odds FLOAT = 2.5
DECLARE @single_odds FLOAT = 1.8
DECLARE @startdate DATETIME = '2022-04-10 20:00'
DECLARE @enddate DATETIME = '2022-10-26 19:59'



DROP TABLE IF EXISTS #nba_checks
SELECT 
    o.OrderID
INTO #nba_checks
FROM
    dwOper.dbo.VIEW_sport_OrdersBetsStakes_TotogamingAm o --Bet Stakes with large opening
    LEFT JOIN dwOper.sport.CashoutHistory h on h.OrderID = o.OrderID -- Cashout 
WHERE 
    o.OrderDate >= @startdate AND o.OrderDate <= @enddate
AND o.CalculationDate >= @startdate AND o.CalculationDate <= @enddate
AND o.OrderStateID NOT IN (1, 4, 7)
AND o.BetCategoryID IN (1, 3)
AND o.TournamentID = 1 -- NBA
AND o.IsInternet = 1  --Internet users
AND h.CashoutId is NULL --No Cashout
AND o.UserBonusID is NULL --No Bonus
GROUP BY o.OrderID

DROP TABLE IF EXISTS #final_checks
SELECT 
    o.OrderID
INTO #final_checks
FROM
    VIEW_sport_OrdersBetsStakes_TotogamingAm o
WHERE
    o.OrderID IN (SELECT * FROM #nba_checks)
AND o.Odds >= @each_odds
GROUP BY 
    o.OrderID
HAVING 
    EXP(SUM(LOG(o.Odds))) >= CASE WHEN MAX(o.BetCategoryID) = 3 then @express_odds else @single_odds end
AND SUM(o.StakeAmount) >= @min_order_amount
AND COUNT(o.StakeID) = MAX(o.BetCount)

DROP TABLE IF EXISTS #User_Days
SELECT 
    u.PartnerUserId,
    COUNT(DISTINCT CAST(DATEADD(hour, 4, o.OrderDate) AS DATE)) as count_of_days
INTO #User_Days
FROM 
    dwOper.dbo.VIEW_sport_OrdersBetsStakes_TotogamingAm o
    LEFT JOIN VIEW_sport_PartnerUser_TotogamingAm u on u.UserID = o.UserID
WHERE 
    o.OrderID IN (SELECT * FROM #final_checks)
GROUP BY 
    u.PartnerUserId

-- SELECT * FROM #User_Days

DROP TABLE IF EXISTS #almost_full
SELECT 
    u.PartnerUserId,
    o.OrderID,
    SUM(o.winamount) - SUM(o.StakeAmount) Pure_Win,
    CASE WHEN SUM(o.winamount) - SUM(o.StakeAmount) > 0 THEN
    (SUM(o.winamount) - SUM(o.StakeAmount)) ELSE 0 END Points
INTO #almost_full
FROM 
    dwOper.dbo.VIEW_sport_OrdersBetsStakes_TotogamingAm o
    LEFT JOIN VIEW_sport_PartnerUser_TotogamingAm u on u.UserID = o.UserID
    LEFT JOIN VIEW_PlatformPartnerUsers_TotogamingAm cu on cu.PartnerUserId = u.PartnerUserId 
WHERE 
    o.OrderID IN (SELECT * FROM #final_checks)
GROUP BY 
    u.PartnerUserId, o.OrderID
ORDER BY 
    u.PartnerUserId
-- HAVING  
--     SUM(o.winamount) - SUM(o.StakeAmount) > 0

SELECT a.PartnerUserId, SUM(Points) * MAX(#User_Days.count_of_days) AS Points, SUM(Points) AS Win_points, MAX(#User_Days.count_of_days) AS Days
FROM 
#almost_full a
INNER JOIN #User_Days  ON #User_Days.PartnerUserId = a.PartnerUserId
WHERE a.Pure_Win > 0
GROUP BY a.PartnerUserId
-- SELECT count_of_days FROM #User_Days
