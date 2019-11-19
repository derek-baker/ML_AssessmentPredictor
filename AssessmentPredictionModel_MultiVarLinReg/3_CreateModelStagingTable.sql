
DROP TABLE IF EXISTS ML.dbo.AssessmentPyModelsMultiVarLinReg;
GO
CREATE TABLE ML.dbo.AssessmentPyModels (
    model_name VARCHAR(30) NOT NULL DEFAULT('default model') PRIMARY KEY,
    model VARBINARY(MAX) NOT NULL
);
GO