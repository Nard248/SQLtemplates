DECLARE 
@start DATETIME = '2022-07-01 00:00:00',
@end DATETIME = '2022-10-12 00:00:00',
@user int = 101377551

SELECT PartnerUserId, 
    Trans_Date, 
    SUM(Amount) Amount,
    'Deposit' TransactionType,
	Platforms 
    FROM( 
    SELECT u.PartnerUserId,
    	--dd.FirstOfMonth Month,
        p.Trans_Date,
    	SUM(p.LeftAmount) Amount,
    	'Deposit' TransactionType,
    	'Sport' Platforms
    FROM Payment AS p
    INNER JOIN VIEW_sport_PartnerUser_TotogamingAm AS u ON u.UserID = p.UserID
    --INNER JOIN DIM_Date dd on dd.date=convert(date, p.Trans_Date)
    LEFT JOIN C_PaymentSystem ps ON ps.PaymentSystemId = p.PaymentSystemID
    WHERE p.TransactionTypeID IN (62,65,70,73,87,88,102,103,75,71)
    	AND p.Trans_Date >= @start
    	AND p.Trans_Date < @end
    	AND p.Fund_StatusID IN (3,23,31,53,63,106)
    	AND u.PartnerID IN (943)
    	AND p.SourceID = 1
    	AND u.PartnerUserId < @user
    	AND ps.PaymentSystemName NOT IN ('Casino Transfer','BONUS')
    GROUP BY u.PartnerUserId, p.Trans_Date --dd.FirstOfMonth

    UNION ALL

    SELECT u.PartnerUserId,
    	-- dd.FirstOfMonth month,
        p.Trans_Date,
    	SUM(p.LeftAmount) Amount,
    	'Deposit' TransactionType,
    	'Casino' Platforms
    FROM Payment AS p
    INNER JOIN C_PaymentSystem AS ps ON ps.PaymentSystemId = p.PaymentSystemID
    INNER JOIN VIEW_PlatformPartnerUsers_TotogamingAm AS u ON u.UserID = p.UserID
    -- INNER JOIN DIM_Date dd on dd.date=convert(date,p.modify_date)
    WHERE p.PaymentTypeID = 2
    	AND p.PaymentStatusID = 8
    	AND p.modify_date >= @start
    	AND p.modify_date < @end
    	AND ps.PaymentSystemName NOT IN ('PokerTransfer','TRANSFER')
    	AND u.PartnerID IN (237)
    	AND p.SourceID = 2
    	AND u.PartnerUserId < @user
    GROUP BY u.PartnerUserId, p.Trans_Date) full_table
WHERE Trans_Date is not NULL
GROUP BY PartnerUserId, Trans_Date, Platforms
ORDER BY Platforms ASC