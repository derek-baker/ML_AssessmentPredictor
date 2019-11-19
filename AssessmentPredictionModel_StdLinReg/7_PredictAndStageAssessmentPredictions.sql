
TRUNCATE TABLE ML.dbo.AssessmentPredictions_LinReg
INSERT INTO ML.dbo.AssessmentPredictions_LinReg
EXEC ML.dbo.usp_PredictAssessmentWithLinReg 'linear_model';


SELECT * FROM ML.dbo.AssessmentPredictions_LinReg;