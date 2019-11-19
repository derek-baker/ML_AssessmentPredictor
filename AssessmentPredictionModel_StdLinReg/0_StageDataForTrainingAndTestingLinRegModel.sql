-- NOTE: The independent variable for this model will be Acres, 
-- 		 so we can use data from different NYS counties.


DROP TABLE IF EXISTS ML.dbo.AssessmentTrainingDataLinReg
SELECT DISTINCT
	ParcelId = a.Parcel_ID,
	a.Swis,	
	a.TotalAV,
	Acres = p.[TOTAL ACREAGE],
	Zip = CAST( REPLACE( REPLACE(p.[ZIP CODE], '-', ''), '.', '') AS int)
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
	ML.dbo.AssessmentTrainingDataLinReg
FROM 
	Parcel56.dbo.ASSMT a
	LEFT JOIN Parcel56.dbo.PROPERTY p on a.Parcel_ID = p.PARCEL_ID
WHERE 
	a.RollYr = 2020
	AND
	a.PROP_CLASS = 210
	AND
	ISNUMERIC(p.[ZIP CODE]) = 1	


DROP TABLE IF EXISTS ML.dbo.AssessmentTestingDataLinReg
SELECT DISTINCT
	ParcelId = a.Parcel_ID,
	a.Swis,	
	a.TotalAV,
	Acres = p.[TOTAL ACREAGE],
	Zip = CAST( REPLACE( REPLACE(p.[ZIP CODE], '-', ''), '.', '') AS int)
INTO
	ML.dbo.AssessmentTestingDataLinReg
FROM 
	Parcel16.dbo.ASSMT a
	LEFT JOIN Parcel56.dbo.PROPERTY p on a.Parcel_ID = p.PARCEL_ID
WHERE 
	a.RollYr = 2020
	AND
	a.PROP_CLASS = 210
	AND
	ISNUMERIC(p.[ZIP CODE]) = 1

