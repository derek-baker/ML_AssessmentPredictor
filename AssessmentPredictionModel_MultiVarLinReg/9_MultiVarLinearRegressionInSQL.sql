--table
-------
--X (numeric) = Acres
--Y (numeric) = TotalAV

/**
 * m = (nSxy - SxSy) / (nSxx - SxSx)
 * b = Ay - (Ax * m)
 * N.B. S = Sum, A = Mean
 */

--DECLARE @n INT
--SELECT @n = COUNT(*) FROM table
--SELECT (@n * SUM(X*Y) - SUM(X) * SUM(Y)) / (@n * SUM(X*X) - SUM(X) * SUM(X)) AS M,
--       AVG(Y) - AVG(X) *
--       (@n * SUM(X*Y) - SUM(X) * SUM(Y)) / (@n * SUM(X*X) - SUM(X) * SUM(X)) AS B
--FROM table

USE Parcel56

DECLARE @n int = (SELECT COUNT(*) FROM CleanedAssessmentData)

DROP TABLE IF EXISTS #CleanedAssessmentData
SELECT TOP 25 PERCENT * 
INTO #CleanedAssessmentData 
FROM CleanedAssessmentData d
WHERE d.Acres <> 0

DECLARE @M int;
DECLARE @B int;

SELECT @M = (@n * SUM(Acres * TotalAV) - SUM(Acres) * SUM(TotalAV)) / (@n * SUM(Acres * Acres) - SUM(Acres) * SUM(Acres))
FROM #CleanedAssessmentData

SELECT @B = AVG(TotalAV) - AVG(Acres) * (@n * SUM(Acres * TotalAV) - SUM(Acres) * SUM(TotalAV)) / (@n * SUM(Acres * Acres) - SUM(Acres) * SUM(Acres))
FROM #CleanedAssessmentData

SELECT
	TotAvEst = @M * d.Acres + @B,
	TotalAV,
	Acres,
	Zip
FROM	
	CleanedAssessmentData d
WHERE 
	d.Acres <> 0
ORDER BY
	--Zip,
	Acres
		
