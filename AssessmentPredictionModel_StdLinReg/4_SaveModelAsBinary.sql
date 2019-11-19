DECLARE @model VARBINARY(MAX);
EXEC ML.dbo.usp_GenerateAssessmentPyLinearModel @model OUTPUT;

TRUNCATE TABLE ML.dbo.AssessmentPyLinRegModels
INSERT INTO ML.dbo.AssessmentPyLinRegModels(model_name, model) 
VALUES('linear_model', @model);