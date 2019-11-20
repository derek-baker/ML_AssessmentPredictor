-- PURPOSE: Staging training and testing data to fit ML models to.

-- NOTE: The independent variable for this model will be square feet of living area, 
-- 		 so we can use data from different NYS counties (Assuming the markets are similar)


DROP TABLE IF EXISTS ML.dbo.AssessmentTrainingDataMultiVarLinReg
SELECT DISTINCT
    -- Swis = [SWIS CODE]
    -- ,TaxId = CAST(r.TAXID AS bigint)
	-- ,RowNum = ROW_NUMBER() OVER (ORDER BY r.[SWIS CODE], r.[TAXID])
    ConditionCode = [OVERALL CONDITION]
    ,Sqft = CAST([SQUARE FOOT LIVING AREA] AS bigint)
    ,NumBaths = [NO OF BATHS]
    ,NumBedrooms = [NO OF BEDROOMS]
    ,Age = YEAR(GETDATE()) - [YEAR BUILT]
    ,TotalAV = CAST(a.TotalAV / 1000 as bigint)
INTO
	ML.dbo.AssessmentTrainingDataMultiVarLinReg
FROM 
    [Parcel56].[dbo].[RES] r
    LEFT JOIN [Parcel56].[dbo].ASSMT a ON r.PARCEL_ID = a.Parcel_ID AND r.TAXID = a.TaxID AND r.ROLLYR = a.RollYr
WHERE
    [SITE PROPERTY CLASS] = 210
    AND 
    r.ROLLYR = 2020
    AND 
    r.[SQUARE FOOT LIVING AREA] > 0
    AND
    a.TotalAV > 9999
	AND
	a.TotalAV < 10000000


SELECT * FROM ML.dbo.AssessmentTrainingDataMultiVarLinReg ORDER BY TotalAV DESC


DROP TABLE IF EXISTS ML.dbo.AssessmentTestingDataMultiVarLinReg
SELECT DISTINCT
    --Swis = [SWIS CODE]
    -- ,TaxId = CAST(r.TAXID AS bigint)
	--,RowNum = ROW_NUMBER() OVER (ORDER BY r.[SWIS CODE], r.[TAXID])
    ConditionCode = [OVERALL CONDITION]
    ,Sqft = CAST([SQUARE FOOT LIVING AREA] AS bigint)
    ,NumBaths = [NO OF BATHS]
    ,NumBedrooms = [NO OF BEDROOMS]
    ,Age = YEAR(GETDATE()) - [YEAR BUILT]
    ,TotalAV = CAST(a.TotalAV / 1000 as bigint)
INTO
	ML.dbo.AssessmentTestingDataMultiVarLinReg
FROM 
    [Parcel16].[dbo].[RES] r
    LEFT JOIN [Parcel16].[dbo].ASSMT a ON r.PARCEL_ID = a.Parcel_ID AND r.TAXID = a.TaxID AND r.ROLLYR = a.RollYr
WHERE
    [SITE PROPERTY CLASS] = 210
    AND 
    r.ROLLYR = 2020
    AND 
    r.[SQUARE FOOT LIVING AREA] > 0
    AND
    a.TotalAV > 9999
	AND
	a.TotalAV < 10000000


SELECT * FROM ML.dbo.AssessmentTestingDataMultiVarLinReg ORDER BY TotalAV DESC