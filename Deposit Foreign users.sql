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

SELECT u.PartnerUserId,
	cast(p.modify_date AS DATE) Date_dep,
	SUM(p.Amount) Amount,
	'Deposit' TransactionType,
	'Sport' Platforms
FROM Payment AS p
INNER JOIN VIEW_sport_PartnerUser_TotogamingAm AS u ON u.UserID = p.UserID
INNER JOIN #fu fu ON u.PartnerUserId = fu.TOTOID
LEFT JOIN C_PaymentSystem ps ON ps.PaymentSystemId = p.PaymentSystemID
WHERE p.TransactionTypeID IN (62,65,70,73,87,88,102,103,75,71)
	AND p.PaymentTypeId = 2
	AND p.Trans_Date <= DATEADD(DAY, -1, CAST(GETDATE() AS DATE))
	AND p.Fund_StatusID IN (3,23,31,53,63,106)
	AND u.PartnerID IN (943)
	AND p.SourceID = 1
	AND ps.PaymentSystemName NOT IN ('Casino Transfer','BONUS')
GROUP BY u.PartnerUserId, cast(p.modify_date AS DATE)

UNION ALL

SELECT u.PartnerUserId,
	cast(p.modify_date AS DATE) Date_dep,
	SUM(p.Amount) Amount,
	'Deposit' TransactionType,
	'Casino' Platforms
FROM Payment AS p
INNER JOIN C_PaymentSystem AS ps ON ps.PaymentSystemId = p.PaymentSystemID
INNER JOIN VIEW_PlatformPartnerUsers_TotogamingAm AS u ON u.UserID = p.UserID
INNER JOIN #fu fu ON u.PartnerUserId = fu.TOTOID
WHERE p.PaymentTypeID = 2
	AND p.PaymentStatusID = 8
	AND p.modify_date <= DATEADD(DAY, -1, CAST(GETDATE() AS DATE))
	AND ps.PaymentSystemName NOT IN ('PokerTransfer','TRANSFER')
	AND u.PartnerID IN (237)
	AND p.SourceID = 2
GROUP BY u.PartnerUserId, cast(p.modify_date AS DATE)
ORDER BY 1