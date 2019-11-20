-- SOURCE / INSPIRED BY: https://stackoverflow.com/questions/28262939/multiple-linear-regression-function-in-sql-server#answer-28464728
-- AUTHOR'S NOTE: "Linear Least Squares solved via Orthogonal Decomposition using Householder reflections in SQL. (Warning will run slowly on any significant amount of data.)"

USE ML;


-- Get the input data
DECLARE @TestData TABLE (i int IDENTITY(1, 1), X1 int, X2 int, X3 int, X4 int, y float)
INSERT INTO @TestData
SELECT DISTINCT 
	x1 = ConditionCode,
	x2 = Sqft,
	x3 = NumBedrooms,
	x4 = Age,	
	y = TotalAV
FROM
	dbo.AssessmentTestingDataMultiVarLinReg


-- Put our data into dbo.Matrix types
DECLARE @X dbo.Matrix
INSERT INTO @X(i, j, Aij)
-- Extra column for constant
SELECT 
    i, 1, 1
FROM 
    @TestData
UNION
SELECT 
    i, 2, X1
FROM 
    @TestData
UNION
SELECT 
    i, 3, X2
FROM 
    @TestData
UNION
SELECT 
    i, 4, X3
FROM 
    @TestData
UNION
SELECT 
    i, 5, X4
FROM 
    @TestData


DECLARE @y dbo.Matrix
INSERT @y(i, j, Aij)
SELECT 
    i, 1, y
FROM 
    @TestData


-- Store estimates for coefficient values in matrix type
DECLARE @bhat dbo.Matrix
INSERT INTO @bhat(i, j, Aij)
SELECT 
    i, j, Aij
FROM 
    dbo.MatrixLeastSquareRegression(@X, @y)


SELECT 
    y.Aij AS TotalAV, 
	Xb.Aij AS TotalAVEst,
	ConditionCode = x1,
	Sqft = x2,
	NumBedrooms = x3,
	Age = x4	
FROM(
    SELECT 
		x.i, 
		SUM(x.Aij * bh.Aij) AS Aij
    FROM 
		@X x
		INNER JOIN @bhat bh ON bh.i = x.j
    GROUP BY 
		x.i
) Xb
INNER JOIN @y y ON y.i = Xb.i
LEFT JOIN @TestData d ON y.i = d.i
