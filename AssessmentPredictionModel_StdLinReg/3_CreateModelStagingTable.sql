USE Parcel56;

DROP TABLE IF EXISTS dbo.AssessmentPyModels;
GO
CREATE TABLE dbo.AssessmentPyModels (
    model_name VARCHAR(30) NOT NULL DEFAULT('default model') PRIMARY KEY,
    model VARBINARY(MAX) NOT NULL
);
GO