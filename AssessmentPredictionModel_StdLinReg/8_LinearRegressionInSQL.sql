-- INSPIRED BY: https://stackoverflow.com/questions/2536895/are-there-any-linear-regression-function-in-sql-server#answer-3283119
-- PURPOSE: Compute a linear regression to use to QA the ML Model
--  		We visualize the results of this data for a side-by-side comparison of model ouput.

DECLARE @n int = (SELECT COUNT(*) FROM ML.dbo.AssessmentTestingDataLinReg)

DROP TABLE IF EXISTS #AssessmentTestingDataLinReg
SELECT TOP 30 PERCENT 
	Sqft = d.Sqft,
	TotalAV = d.TotalAV 
INTO 
	#AssessmentTestingDataLinReg 
FROM 
	ML.dbo.AssessmentTestingDataLinReg d


DECLARE @M decimal(18,3);
DECLARE @B decimal(18,3);


SELECT 
	@M = CAST( (@n * SUM(Sqft * TotalAV) - SUM(Sqft) * SUM(TotalAV)) AS decimal(18,3)) / (@n * SUM(Sqft * Sqft) - SUM(Sqft) * SUM(Sqft))
FROM #AssessmentTestingDataLinReg


SELECT @B = AVG(TotalAV) - AVG(Sqft) * (@n * SUM(Sqft * TotalAV) - SUM(Sqft) * SUM(TotalAV)) / (@n * SUM(Sqft * Sqft) - SUM(Sqft) * SUM(Sqft))
FROM #AssessmentTestingDataLinReg


SELECT
	TotalAVEst = CAST(@M * d.Sqft + @B AS int), 
	TotalAV = TotalAV,
	Sqft
FROM	
	ML.dbo.AssessmentTestingDataLinReg d
ORDER BY		
	Sqft ASC
		
