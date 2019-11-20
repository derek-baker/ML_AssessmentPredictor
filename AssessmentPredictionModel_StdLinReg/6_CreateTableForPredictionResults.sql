
DROP TABLE IF EXISTS ML.[dbo].[AssessmentPredictions_LinReg];
GO

CREATE TABLE ML.[dbo].[AssessmentPredictions_LinReg](
	[TotalAV_Predicted] [int] NULL,
	[TotalAV_Actual] [int] NULL,
	[ConditionCode] [int] NULL,
	[Sqft] [int] NULL,
	[NumBaths] [int] NULL,
	[NumBedrooms] [int] NULL,
	[Age] [int] NULL
) ON [PRIMARY]
GO