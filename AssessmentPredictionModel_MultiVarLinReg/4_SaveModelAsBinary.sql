
DECLARE @model VARBINARY(MAX);
EXEC ML.dbo.usp_GenerateAssessmentPyMultiValLinearModel @model OUTPUT;

TRUNCATE TABLE ML.dbo.AssessmentPyModelsMultiVarLinReg
INSERT INTO ML.dbo.AssessmentPyModelsMultiVarLinReg(model_name, model) 
VALUES('linear_model', @model);