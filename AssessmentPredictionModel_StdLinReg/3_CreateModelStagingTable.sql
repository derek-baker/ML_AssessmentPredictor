DROP TABLE IF EXISTS ML.dbo.AssessmentPyLinRegModels;
GO
CREATE TABLE ML.dbo.AssessmentPyLinRegModels (
    model_name VARCHAR(30) NOT NULL DEFAULT('default model') PRIMARY KEY,
    model VARBINARY(MAX) NOT NULL
);
GO