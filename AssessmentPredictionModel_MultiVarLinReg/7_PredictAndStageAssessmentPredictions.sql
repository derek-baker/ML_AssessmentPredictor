USE ML


TRUNCATE TABLE [dbo].[AssessmentPredictions_MultiVarLinReg]
INSERT INTO [dbo].[AssessmentPredictions_MultiVarLinReg]
EXEC usp_PredictAssessment 'linear_model';


SELECT 
    * 
FROM 
    [dbo].[AssessmentPredictions_MultiVarLinReg];


-- Smaller set for comparison of SQL-based method
SELECT DISTINCT TOP 300
    TotalAV,
    TotalAV_Predicted,
    p.ConditionCode, 
    p.Sqft, 
    p.NumBedrooms, 
    p.Age,
    RowNumber = ROW_NUMBER() OVER (ORDER BY p.Sqft, p.NumBedrooms, p.ConditionCode, p.Age)
FROM 
    [dbo].[AssessmentPredictions_MultiVarLinReg] p