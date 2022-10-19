-- SELECT *
-- FROM VIEW_sport_PartnerUser_TotogamingAm
-- WHERE PartnerUserId = 100838921

SELECT 
    o.UserID, o.OrderID, o.StakeAmount, o.BetAmount, o.Odds, o.WinAmount
FROM
    dwOper.dbo.VIEW_sport_OrdersBetsStakes_TotogamingAm o --Bet Stakes with large opening
    LEFT JOIN dwOper.sport.CashoutHistory h on h.OrderID = o.OrderID -- Cashout 
WHERE 
    o.OrderDate >= '2022-04-10 20:00' AND o.OrderDate <= '2022-10-26 19:59'
AND o.CalculationDate >= '2022-04-10 20:00' AND o.CalculationDate <= '2022-10-26 19:59'
AND o.UserID = 1981177
AND o.OrderStateID NOT IN (1, 4, 7)
AND o.BetCategoryID IN (1, 3)
AND o.TournamentID = 1 -- NBA
AND o.IsInternet = 1  --Internet users
AND h.CashoutId is NULL --No Cashout
AND o.UserBonusID is NULL --No Bonus
ORDER BY o.OrderID 
