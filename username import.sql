DROP TABLE IF EXISTS #cg
	SELECT cg.GameID, 
        cg.GameCategoryID, 
        cg.GameProviderID, 
        cg.Name_en
	INTO #cg
	FROM C_Game cg
DROP TABLE IF EXISTS #gc
	SELECT gc.GameCategoryID, 
        gc.GameCategoryName
	INTO #gc
	FROM C_GameCategory gc
DROP TABLE IF EXISTS #gp
	SELECT gp.GameProviderID, 
        gp.GameProviderName
	INTO #gp
	FROM C_GameProvider gp
DROP TABLE IF EXISTS #a
	SELECT #cg.GameID, 
        #cg.Name_en, 
        #gc.GameCategoryName, 
        #gp.GameProviderName
	INTO #a
	FROM #cg
	LEFT JOIN #gc ON #cg.GameCategoryID = #gc.GameCategoryID
	LEFT JOIN #gp ON #cg.GameProviderID = #gp.GameProviderID
DROP TABLE IF EXISTS #fu
	SELECT 
	    u.PartnerUserId AS TOTOID,
	    u.FirstName,
	    u.LastName,
	    u.MobileNumber,
	    u.Country
	INTO #fu
	FROM VIEW_PlatformPartnerUsers_TotogamingAm u
	WHERE u.RegistrationDate > '2022-08-23 20:00:00'
	AND u.LastName not  like '%yan'
	AND u.LastName not like '%ian'
	AND u.LastName not like '%ян'
	AND u.LastName not like '%unts'
	AND u.LastName not like '%uni'
	AND u.LastName not like '%yants'
	AND u.FirstName not like 'tst%'
	AND u.isDeleted = 0
	AND u.UserTypeID not in(20,3,21)
	AND u.UserStatusID = 4
	AND u.UserName not like 'test%'
	AND u.UserName not like '%TestClient%'


DROP TABLE IF EXISTS #cas
	SELECT u.PartnerUserID, 
		u.UserName,
        a.CalculationDate_DT as order_Date,
        COUNT(a.OrderID) as BetCount, 
        SUM(a.BetAmount) as BetAmount, 
        SUM(a.GGR) as GGR,
        g.GameID
	INTO #cas
	FROM (
		SELECT o.UserID, 
            o.GameID, 
			o.OrderID,
            o.CalculationDate_DT,
            CASE WHEN cg.GameProviderID IN (48, 10) AND o.TypeId IN (1, 5, 8, 18, 33) THEN o.OrderAmount 
            WHEN cg.GameProviderID NOT IN (48, 10) THEN o.OrderAmount ELSE 0 END AS BetAmount,
            CASE WHEN cg.GameProviderID IN (48, 10) AND o.TypeId = 1 THEN o.OrderAmount * o.Odds / 100 
            WHEN cg.GameProviderID IN (48, 10) AND o.TypeId IN (5, 8, 18, 33) THEN (o.OrderAmount - o.WinAmount) 
            WHEN cg.GameProviderID NOT IN (48, 10) THEN (o.OrderAmount - o.WinAmount) 
            ELSE 0 END GGR
		FROM casino.orders o
		INNER JOIN C_Game cg ON cg.GameID = o.GameID
		WHERE o.CalculationDate_DT < DATEADD(DAY, -1, CAST(GETDATE() AS DATE))
			AND o.DeviceTypeID = 12
            AND o.OrderStateID NOT IN (1, 4, 7)
			AND o.OperationTypeID IN (3, 299)
			AND CASE WHEN cg.GameProviderID IN (48, 10)
            THEN o.TypeId ELSE 0 END IN (0, 1, 5, 8, 18, 33)
		) a
	INNER JOIN C_Game g ON g.GameID = a.GameID
	INNER JOIN VIEW_PlatformPartnerUsers_TotogamingAm u ON u.UserID = a.UserID
	INNER JOIN #fu fu ON fu.TOTOID = u.PartnerUserID
	GROUP BY u.PartnerUserID, 
        a.CalculationDate_DT,
        a.BetAmount, 
        g.GameID,
		u.UserName





SELECT #cas.PartnerUserId AS TOTOID, 
    #cas.order_Date AS OrderDate,
    SUM(#cas.BetCount) AS BetCount, 
    SUM(#cas.BetAmount) AS BetAmount, 
    SUM(#cas.GGR) AS GGR,
    #b.Type AS Type,
    #b.GameProviderName AS Provider,
	'Digitain Platform' AS Platform,
	'Internet' AS Internet,
	#cas.UserName AS Login
FROM #cas
LEFT JOIN (SELECT *, 
        (
						CASE 
				WHEN #a.Name_en LIKE '%HabaneroJackpot%'
					THEN 'Other'
				WHEN #a.GameProviderName LIKE '%Kiron%'
					THEN 'Virtual Games'
				WHEN #a.Name_en LIKE '%Greyhound Racing%'
					THEN 'Virtual Games'
				WHEN #a.Name_en LIKE '%Penalty Shootout%'
					THEN 'Virtual Games'
				WHEN #a.Name_en LIKE '%Flat Horse Racing%'
					THEN 'Virtual Games'
				WHEN #a.Name_en LIKE '%Fantastic League%'
					THEN 'Virtual Games'
				WHEN #a.Name_en LIKE '%Horse Racing%'
					THEN 'Virtual Games'
                WHEN #a.Name_en LIKE '%English league%'
					THEN 'Virtual Games'
				WHEN #a.GameProviderName LIKE '%Digitain%'
					AND #a.Name_en LIKE '%Football Single Match%'
					THEN 'Virtual Games'
				WHEN #a.GameProviderName LIKE '%GlobalBet%'
					THEN 'Virtual Games'
				WHEN #a.GameProviderName LIKE '%GoldenRace%'
					and #a.Name_en in ('Keno','Keno Deluxe')
					THEN 'TVGames'
				WHEN #a.GameProviderName LIKE '%Golden%'
					THEN 'Virtual Games'
				WHEN #a.GameProviderName LIKE '%EventBet%'
					THEN 'Poker'
				WHEN #a.GameProviderName LIKE '%Betgames%'
					THEN 'TVGames'
				WHEN #a.GameProviderName LIKE '%Atmosfera%'
				AND #a.Name_en in ('Bingo 37','Keno','Bingo 38')
					THEN 'TVGames'
				WHEN #a.GameProviderName = 'FLG'
				AND #a.Name_en in ('Keno Gold')
					THEN 'TVGames'
				WHEN #a.GameProviderName LIKE '%Betongames%'
					THEN 'Betongames'
				WHEN #a.GameProviderName LIKE '%Evolution%'
					THEN 'Live Casino'
				WHEN #a.GameProviderName LIKE '%LiveCasino%'
					THEN 'Live Casino'
				WHEN #a.GameProviderName LIKE '%EzugiOriginal%'
					THEN 'Live Casino'
				WHEN #a.GameProviderName LIKE '%LuckyStreak%'
					THEN 'Live Casino'
				WHEN #a.GameProviderName LIKE '%VivoGaming%'
					THEN 'Live Casino'
				WHEN #a.GameProviderName LIKE '%NetEntLiveCasino%'
					THEN 'Live Casino'
				WHEN #a.GameProviderName LIKE '%TV Bet%'
					THEN 'TVGames'
				WHEN #a.GameProviderName LIKE '%BetGames%'
					THEN 'TVGames'
				WHEN #a.GameCategoryName LIKE '%P2P%'
					THEN 'P2P'
				WHEN #a.GameProviderName LIKE '%GGPoker%'
					THEN 'Poker'
				WHEN #a.GameCategoryName LIKE '%Slot%'
					THEN 'Slots'
				WHEN #a.GameProviderName LIKE '%InBet%'
					THEN 'Virtual Games'
				WHEN #a.GameProviderName LIKE '%Leap%'
					THEN 'Virtual Games'
				WHEN #a.GameProviderName LIKE '%Digitain Live Casino%'
					THEN 'Live Casino'
				WHEN #a.GameProviderName LIKE '%Digitain%'
					THEN 'Sport'
				WHEN #a.GameProviderName LIKE '%Pragmatic%'
					AND #a.GameCategoryName LIKE '%Baccarat%'
					THEN 'Live Casino'
				WHEN #a.GameProviderName LIKE '%Pragmatic%'
					AND #a.GameCategoryName LIKE '%Blackjack%'
					THEN 'Live Casino'
				WHEN #a.GameProviderName LIKE '%Pragmatic%'
					AND #a.GameCategoryName LIKE '%Roulette%'
					THEN 'Live Casino'
				WHEN #a.GameProviderName LIKE '%Pragmatic%'
					AND #a.GameCategoryName LIKE '%TV Show%'
					THEN 'Live Casino'
				WHEN #a.GameProviderName LIKE '%Pragmatic%'
					AND #a.GameCategoryName LIKE '%GameShow%'
					THEN 'Live Casino'
				WHEN #a.GameProviderName LIKE '%Pragmatic%'
					AND #a.Name_en LIKE '%Mega Sic Bo%'
					THEN 'Live Casino'
				WHEN #a.GameProviderName LIKE '%Pragmatic%'
					AND #a.Name_en LIKE '%Dragon Tiger%'
					THEN 'Live Casino'
				WHEN #a.GameProviderName LIKE '%Pragmatic%'
					AND #a.Name_en LIKE '%Andar Bahar%'
					THEN 'Live Casino'
				WHEN #a.Name_en LIKE '%Dynamic Roulette 120x%'
					THEN 'Live Casino'
				WHEN #a.Name_en LIKE '%Live European Roulette%'
					THEN 'Live Casino'
				WHEN #a.GameProviderName LIKE '%Atmosfera%'
					AND #a.Name_en LIKE '%Live Roulette%'
					THEN 'Live Casino'
				WHEN #a.GameProviderName LIKE '%Atmosfera%'
					AND #a.Name_en LIKE '%Music Wheel%'
					THEN 'Live Casino'
				WHEN #a.GameProviderName LIKE '%Atmosfera%'
				 AND #a.Name_en LIKE '%Auto Roulette%'
					THEN 'Live Casino'
				WHEN #a.GameProviderName LIKE '%XPG%'
					THEN 'Live Casino'
				WHEN #a.GameProviderName LIKE '%EGT%'
					AND #a.Name_en LIKE '%Onyx Roulette%'
					THEN 'Live Casino'
				WHEN #a.GameProviderName LIKE '%EGT%'
					AND #a.Name_en LIKE '%Live Speed Roulette%'
					THEN 'Live Casino'
				WHEN #a.GameProviderName LIKE '%EGT%'
					AND #a.Name_en LIKE '%Vegas Roulette 500x%'
					THEN 'Live Casino'
				WHEN #a.GameProviderName LIKE '%PlayngoArmenia%'
					AND #a.Name_en LIKE '%European Roulette Pro%'
					THEN 'Slots'
				WHEN #a.GameProviderName LIKE '%EGT%'
					AND #a.Name_en LIKE '%Burning Keno Plus%'
					THEN 'Slots'
				WHEN #a.GameProviderName LIKE '%1x2%'
					AND #a.Name_en LIKE '%Instant Football%'
					THEN 'Virtual Games'
				WHEN #a.GameProviderName LIKE '%EGT%'
					AND #a.Name_en LIKE '%European Roulette%'
					THEN 'Slots'
				ELSE 'Other'
                END
		) Type
	FROM #a ) #b ON #cas.GameID = #b.GameID
GROUP BY PartnerUserId, order_Date, Type, GameProviderName, #cas.UserName

UNION ALL 

SELECT u.PartnerUserID AS TOTOID, 
	o.OrderDate AS OrderDate, 
	COUNT(o.OrderID) AS BetCount, 
	SUM(o.OrderAmount) AS BetAmount, 
	SUM(o.StakeAmount) - SUM(o.WinAmount) AS GGR, 
	'Sports' AS Type,
	'Toto' AS Provider,
	'BE Platform' AS Platform,
	CASE WHEN IsInternet = 1 Then 'Internet' ELSE 'BetShop' END AS Internet,
	u.UserName AS Login,
FROM VIEW_sport_PartnerUser_TotogamingAm u
INNER JOIN VIEW_sport_OrdersBetsStakes_TotogamingAm o ON o.UserID = u.UserID
INNER JOIN #fu fu ON u.PartnerUserId = fu.TOTOID
WHERE o.OrderDate_DT <= CAST(DATEADD(DAY, -1, CAST(GETDATE() AS DATE)) AS Date)
AND o.OrderStateID NOT IN (1, 4, 7)
AND u.UserTypeID NOT IN (1, 20, 3, 21)
GROUP BY u.PartnerUserId, o.OrderDate, IsInternet, UserName

