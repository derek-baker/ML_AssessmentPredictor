-- Stage all data
DROP TABLE IF EXISTS #Staging
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
	#Staging 
FROM 
	Parcel56.dbo.ASSMT a
	LEFT JOIN Parcel56.dbo.PROPERTY p on a.Parcel_ID = p.PARCEL_ID
WHERE 
	a.RollYr = 2020
	AND
	a.PROP_CLASS = 210
	AND
	ISNUMERIC(p.[ZIP CODE]) = 1
	

-- Separate half of the data for training (and hope for a relatively even distribution of data)
DROP TABLE IF EXISTS AssessmentTrainingDataMultiVarLinReg
SELECT TOP 50 PERCENT
	ParcelId,
	Swis,	
	TotalAV,
	Acres,
	Zip
INTO
	AssessmentTrainingDataMultiVarLinReg
FROM 
	#Staging
ORDER BY	
	Zip ASC


-- Separate half of the data for testing (and hope for a relatively even distribution of data)
DROP TABLE IF EXISTS AssessmentTestingDataMultiVarLinReg
SELECT TOP 50 PERCENT
	ParcelId,
	Swis,	
	TotalAV,
	Acres,
	Zip
INTO
	AssessmentTestingDataMultiVarLinReg
FROM 
	#Staging
ORDER BY	
	Zip DESC