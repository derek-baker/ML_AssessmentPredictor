USE Parcel56

DECLARE @model VARBINARY(MAX);
EXEC usp_GenerateAssessmentPyModel @model OUTPUT;

TRUNCATE TABLE dbo.AssessmentPyModels
INSERT INTO dbo.AssessmentPyModels (model_name, model) VALUES('linear_model', @model);