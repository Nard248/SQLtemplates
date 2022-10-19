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
	
--Casino BETS
DROP TABLE IF EXISTS #cas
	SELECT u.PartnerUserID, 
        count(*) as BetCount, 
        a.BetAmount, 
        g.GameID
	INTO #cas
	FROM (
		SELECT o.UserID, 
            o.GameID, 
            (CASE WHEN o.CalculationDate < '2021-03-01' THEN o.OrderAmount ELSE 
                CASE WHEN cg.GameProviderID IN (48, 10) AND o.TypeId IN (1, 5, 8, 18, 33) THEN o.OrderAmount 
                WHEN cg.GameProviderID NOT IN (48, 10) THEN o.OrderAmount ELSE 0 END END) AS BetAmount
		FROM casino.orders o
		INNER JOIN C_Game cg ON cg.GameID = o.GameID
		WHERE o.CalculationDate >= '2022-09-01'
		    AND o.CalculationDate<'2022-09-21'
			AND o.OrderStateID NOT IN (1, 4, 7)
			AND o.OperationTypeID IN (3)
			AND CASE WHEN cg.GameProviderID IN (48, 10)
			AND o.CalculationDate < '2021-03-01' THEN o.TypeId ELSE 0 END IN (0, 1, 5, 8, 18, 33)
		) a
	INNER JOIN C_Game g ON g.GameID = a.GameID
	INNER JOIN VIEW_PlatformPartnerUsers_TotogamingAm u ON u.UserID = a.UserID
	WHERE u.isDeleted = 0
		AND u.PartnerID = 237
		AND u.UserTypeID NOT IN (1, 20, 3, 21)
		AND u.UserName NOT LIKE 'test%'
		AND u.UserName NOT LIKE '%TestClient%'
	GROUP BY u.PartnerUserID, 
        a.BetAmount, 
        g.GameID
		
		







SELECT #cas.PartnerUserId, 
    #cas.BetCount, 
    #cas.BetAmount, 
    #b.Type,
    #b.GameProviderName
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
	Where #b.Type='Slots'
ORDER BY 1 