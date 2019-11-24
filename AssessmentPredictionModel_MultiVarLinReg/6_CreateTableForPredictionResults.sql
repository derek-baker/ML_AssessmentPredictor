USE ML

DROP TABLE IF EXISTS [dbo].[AssessmentPredictions_MultiVarLinReg];
GO

CREATE TABLE [dbo].[AssessmentPredictions_MultiVarLinReg](
	[TotalAV_Predicted] [int] NULL,
	MeanSquaredError nvarchar(100) NULL,
	[TotalAV] [int] NULL,
	[ConditionCode] [int] NULL,
	[Sqft] [int] NULL,
	[NumBedrooms] [int] NULL,
	[Age] [int] NULL
) ON [PRIMARY]
GO