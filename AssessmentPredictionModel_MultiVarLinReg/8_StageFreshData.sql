

DROP TABLE IF EXISTS Parcel56.dbo.CleanedAssessmentData
SELECT 
	ParcelId = a.Parcel_ID,
	a.Swis,	
	a.TotalAV,
	Acres = p.[TOTAL ACREAGE],
	Zip = REPLACE(p.[ZIP CODE], '-', '')	
INTO
	Parcel56.dbo.CleanedAssessmentData
FROM 
	Parcel16.dbo.ASSMT a
	LEFT JOIN property p on a.Parcel_ID = p.PARCEL_ID
WHERE 
	a.RollYr = 2020
	AND
	a.PROP_CLASS = 210
	AND
	ISNUMERIC(p.[ZIP CODE]) = 1


SELECT * FROM Parcel56.dbo.CleanedAssessmentData
	

