-- SOURCE: https://stackoverflow.com/questions/28262939/multiple-linear-regression-function-in-sql-server#answer-28464728

USE ML;

-- Create a type to repsent a 2D Matrix
CREATE TYPE dbo.Matrix AS TABLE (i int, j int, Aij float, PRIMARY KEY (i, j))
GO


-- Function to perform QR factorisation ie A -> QR
CREATE FUNCTION dbo.QRDecomposition (
    @matrix dbo.Matrix READONLY
)
RETURNS @result TABLE (matrix char(1), i int, j int, Aij float)
AS
BEGIN
    DECLARE @m int, @n int, @i int, @j int, @a float

    SELECT @m = MAX(i), @n = MAX(j)
    FROM @matrix

    SET @i = 1
    SET @j = 1

    DECLARE @R dbo.Matrix
    DECLARE @Qj dbo.Matrix
    DECLARE @Q dbo.Matrix

    -- Generate a @m by @m Identity Matrix to transform to Q, add more numbers for m > 1000 
    ;WITH e1(n) AS
    (
        SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL 
        SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL 
        SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1
    ),
    e2(n) AS (SELECT 1 FROM e1 CROSS JOIN e1 AS b),
    e3(n) AS (SELECT 1 FROM e1 CROSS JOIN e2),
    numbers(n) AS (SELECT ROW_NUMBER() OVER (ORDER BY n) FROM e3)
    INSERT INTO @Q (i, j, Aij)
    SELECT i.n, j.n, CASE WHEN i.n = j.n THEN 1 ELSE 0 END 
    FROM numbers i
    CROSS JOIN numbers j
    WHERE i.n <= @m AND j.n <= @m 

    -- Copy input matrix to be transformed to R
    INSERT @R (i, j, Aij)
    SELECT i, j, Aij
    FROM @matrix

    -- Loop performing Householder reflections
    WHILE @j < @n OR (@j = @n AND @m > @n)  BEGIN

        SELECT @a = SQRT(SUM(Aij * Aij))
        FROM @R
        WHERE j = @j
            AND i >= @i

        SELECT @a = -SIGN(Aij) * @a
        FROM @R
        WHERE j = @j AND i = @j + (@j - 1)

        ;WITH u (i, j, Aij) AS (
            SELECT i, 1, u.ui
            FROM (
                SELECT i, CASE WHEN i = j THEN Aij + @a ELSE Aij END AS ui
                FROM @R
                WHERE j = @j
                    AND i >= @i
            ) u
        )
        INSERT @Qj (i, j, Aij)
        SELECT i, j, CASE WHEN i = j THEN 1 - 2 * Aij ELSE - 2 * Aij END as Aij
        FROM (
            SELECT u.i, ut.i AS j, u.Aij * ut.Aij / (SELECT SUM(Aij * Aij) FROM u) AS Aij
            FROM u u
            CROSS JOIN u ut
        ) vvt

        -- Apply inverse Householder reflection to Q
        UPDATE Qj
            SET Aij = [Qj+1].Aij
        FROM @Q Qj
        INNER JOIN ( 
            SELECT Q.i, QjT.j, SUM(QjT.Aij * Q.Aij) AS Aij
            FROM @Q Q
            INNER JOIN (
                SELECT i AS j, j AS i, Aij
                FROM @Qj
            ) QjT ON QjT.i = Q.j 
            GROUP BY Q.i, QjT.j
        ) [Qj+1] ON [Qj+1].i = Qj.i AND [Qj+1].j = Qj.j

        -- Apply Householder reflections to R
        UPDATE Rj
            SET Aij = [Rj+1].Aij
        FROM @R Rj
        INNER JOIN ( 
            SELECT Qj.i, R.j, SUM(Qj.Aij * R.Aij) AS Aij
            FROM @Qj Qj
            INNER JOIN @R R ON R.i = Qj.j 
            GROUP BY Qj.i, R.j
        ) [Rj+1] ON [Rj+1].i = Rj.i AND [Rj+1].j = Rj.j

        -- Prepare Qj for next Householder reflection
        UPDATE @Qj
            SET Aij = CASE WHEN i = j THEN 1 ELSE 0 END
        WHERE i <= @j OR j <= @j

        DELETE FROM @Qj WHERE i > @j AND j > @j

        SET @j = @j + 1
        SET @i = @i + 1

    END

    -- Output Q
    INSERT @result (matrix, i, j, Aij)
    SELECT 'Q', i, j, Aij
    FROM @Q

    -- Output R
    INSERT @result (matrix, i, j, Aij)
    SELECT 'R', i, j, Aij
    FROM @R

    RETURN
END 
GO


-- Function to perform linear regression
CREATE FUNCTION dbo.MatrixLeastSquareRegression (
    @X dbo.Matrix READONLY
    , @y dbo.Matrix READONLY
)
RETURNS @b TABLE (i int, j int, Aij float)
AS
BEGIN
    DECLARE @QR TABLE (matrix char(1), i int, j int, Aij float)

    INSERT @QR(matrix, i, j, Aij)
    SELECT matrix, i, j, Aij
    FROM dbo.QRDecomposition(@X)

    DECLARE @Qty dbo.Matrix

    -- @Qty = Q'y
    INSERT INTO @Qty(i, j, Aij)
    SELECT a.j, b.j, SUM(a.Aij * b.Aij)
    FROM @QR a
    INNER JOIN @y b ON b.i = a.i
    WHERE a.matrix = 'Q'
    GROUP BY a.j, b.j

    DECLARE @m int, @n int, @i int, @j int, @a float

    SELECT @m = MAX(j)
    FROM @QR R
    WHERE R.matrix = 'R'

    SET @i = @m

    -- Solve Rb = Q'y via back substitution
    WHILE @i > 0 BEGIN
        INSERT @b (i, j, Aij)
        SELECT R.i, 1, ( y.Aij - ISNULL(sumKnown.Aij, 0) ) / R.Aij
        FROM @QR R
        INNER JOIN @Qty y ON y.i = R.i
        LEFT JOIN (
            SELECT SUM(R.Aij * ISNULL(b.Aij, 0)) AS Aij
            FROM @QR R
            INNER JOIN @b b ON b.i = R.j
            WHERE R.matrix = 'R' 
                AND R.i = @i
        ) sumKnown ON 1 = 1
        WHERE R.matrix = 'R' 
            AND R.i = @i
            AND R.j = @i

        SET @i = @i - 1
    END
    RETURN
END 
GO