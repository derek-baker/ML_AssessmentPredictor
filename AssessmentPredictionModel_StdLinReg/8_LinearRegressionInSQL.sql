-- INSPIRED BY: https://stackoverflow.com/questions/2536895/are-there-any-linear-regression-function-in-sql-server#answer-3283119
-- PURPOSE: Compute a linear regression to use to QA the ML Model
--  		We visualize the results of this data for a side-by-side comparison of model ouput.

DECLARE @n int = (SELECT COUNT(*) FROM ML.dbo.AssessmentTestingDataLinReg)

DROP TABLE IF EXISTS #AssessmentTestingDataLinReg
SELECT TOP 25 PERCENT * 
INTO #AssessmentTestingDataLinReg 
FROM ML.dbo.AssessmentTestingDataLinReg d
WHERE d.Acres <> 0

DECLARE @M int;
DECLARE @B int;

SELECT @M = (@n * SUM(Acres * TotalAV) - SUM(Acres) * SUM(TotalAV)) / (@n * SUM(Acres * Acres) - SUM(Acres) * SUM(Acres))
FROM #AssessmentTestingDataLinReg

SELECT @B = AVG(TotalAV) - AVG(Acres) * (@n * SUM(Acres * TotalAV) - SUM(Acres) * SUM(TotalAV)) / (@n * SUM(Acres * Acres) - SUM(Acres) * SUM(Acres))
FROM #AssessmentTestingDataLinReg

SELECT
	TotAvEst = @M * d.Acres + @B,
	TotalAV,
	Acres,
	Zip
FROM	
	ML.dbo.AssessmentTestingDataLinReg d
WHERE 
	d.Acres <> 0
ORDER BY	
	Acres
		
