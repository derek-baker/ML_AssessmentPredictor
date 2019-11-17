USE Parcel56

DROP TABLE IF EXISTS CleanedAssessmentData
SELECT 
	ParcelId = a.Parcel_ID,
	a.Swis,	
	a.TotalAV,
	Acres = p.[TOTAL ACREAGE],
	Zip = REPLACE(p.[ZIP CODE], '-', '')
	--a.RollYr,
	--a.Full_Market_Value,
	--p.DIMENSIONS,	
	--p.BASE_PROP_CLASS,
	--a.PROP_CLASS,
	--p.[PROPERTY CLASS DESC],
	--p.STREET,
	--p.[CITY/STATE],	
	--p.[PARCEL LOCATION NUMBER]	
INTO
	CleanedAssessmentData
FROM 
	ASSMT a
	LEFT JOIN property p on a.Parcel_ID = p.PARCEL_ID
WHERE 
	a.RollYr = 2020
	AND
	a.PROP_CLASS = 210
	AND
	ISNUMERIC(p.[ZIP CODE]) = 1
	

DROP TABLE IF EXISTS dbo.CleanedAssessmentDataForTraining
SELECT TOP 50 PERCENT * 
INTO dbo.CleanedAssessmentDataForTraining
FROM dbo.CleanedAssessmentData