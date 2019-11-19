DROP TABLE IF EXISTS AssessmentTrainingDataLinReg
SELECT DISTINCT
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
	AssessmentTrainingDataLinReg
FROM 
	Parcel56.dbo.ASSMT a
	LEFT JOIN Parcel56.dbo.PROPERTY p on a.Parcel_ID = p.PARCEL_ID
WHERE 
	a.RollYr = 2020
	AND
	a.PROP_CLASS = 210
	AND
	ISNUMERIC(p.[ZIP CODE]) = 1
	



DROP TABLE IF EXISTS AssessmentTestingDataLinReg
SELECT DISTINCT
	ParcelId = a.Parcel_ID,
	a.Swis,	
	a.TotalAV,
	Acres = p.[TOTAL ACREAGE],
	Zip = REPLACE(p.[ZIP CODE], '-', '')	
INTO
	AssessmentTestingDataLinReg
FROM 
	Parcel16.dbo.ASSMT a
	LEFT JOIN Parcel56.dbo.PROPERTY p on a.Parcel_ID = p.PARCEL_ID
WHERE 
	a.RollYr = 2020
	AND
	a.PROP_CLASS = 210
	AND
	ISNUMERIC(p.[ZIP CODE]) = 1
