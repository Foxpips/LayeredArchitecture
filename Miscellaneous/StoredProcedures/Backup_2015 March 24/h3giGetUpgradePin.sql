



CREATE PROC [dbo].[h3giGetUpgradePin]
@customerType INT
AS
BEGIN

-- customerPrepay uses the same value as the orderType (2=contractUpgrade, 3=prepayUpgrade)
DECLARE @ban VARCHAR(20)

SELECT TOP 1 @ban = BillingAccountNumber
FROM h3giUpgrade 
WHERE customerPrepay = @customerType
  AND DateUsed IS NULL 
  AND isBroadband = 0 
  AND mobileNumberAreaCode = 083 
  AND eligibilityStatus = 1 
  --AND dayTimeContactNumberMain <> ''
  AND Locked = 0
ORDER BY DateAdded DESC

SELECT top 1 u.BillingAccountNumber AS BAN, 
  u.NameFirst, 
  u.NameLast, 
  u.mobileNumberAreaCode,
  u.mobileNumberMain, 
  convert(varchar,u.dateOfBirth,103),
  CASE WHEN (cup.password) IS NULL THEN ''
  ELSE cup.password END AS 'password'
  FROM h3giUpgrade u 
	LEFT JOIN  
	h3gicustomerUpgradePassword cup 
	ON cup.upgradeId = u.upgradeId 
  WHERE BillingAccountNumber = @ban
  and Locked = 0
  ORDER BY cup.dateStamp DESC
    
END







GRANT EXECUTE ON h3giGetUpgradePin TO b4nuser
GO
