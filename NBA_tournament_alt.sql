-- https://www.totogaming.am/hy/Dedicated/oct/nba-tournament

DROP TABLE IF EXISTS #nba_checks
SELECT 
    o.OrderID
INTO #nba_checks
FROM
    dwOper.dbo.VIEW_sport_OrdersBetsStakes_TotogamingAm o --Bet Stakes with large opening
    LEFT JOIN dwOper.sport.CashoutHistory h on h.OrderID = o.OrderID -- Cashout 
WHERE 
    o.OrderDate >= '2022-10-18 20:00:00' AND o.OrderDate <= '2022-10-26 19:59:59'
AND o.CalculationDate >= '2022-10-18 20:00:00' AND o.CalculationDate <= '2022-10-26 19:59:59'
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
AND o.Odds >= 1.5
GROUP BY 
    o.OrderID
HAVING 
    EXP(SUM(LOG(o.Odds))) >= CASE WHEN MAX(o.BetCategoryID) = 3 then 2.5 else 1.8 end
AND SUM(o.StakeAmount) >= 500


SELECT 
    cu.Base_UserID,
    SUM(o.winamount) - SUM(o.StakeAmount) Pure_Win,
    COUNT(DISTINCT o.OrderDate_DT) Days,
    (SUM(o.winamount) - SUM(o.StakeAmount)) * COUNT(DISTINCT o.OrderDate_DT) Points
FROM 
    dwOper.dbo.VIEW_sport_OrdersBetsStakes_TotogamingAm o
    LEFT JOIN VIEW_sport_PartnerUser_TotogamingAm u on u.UserID = o.UserID
    LEFT JOIN VIEW_PlatformPartnerUsers_TotogamingAm cu on cu.PartnerUserId = u.PartnerUserId 
WHERE 
    o.OrderID IN (SELECT * FROM #final_checks)
GROUP BY 
    cu.Base_UserID
-- HAVING  
--     SUM(o.winamount) - SUM(o.StakeAmount) > 0