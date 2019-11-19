
DROP TABLE IF EXISTS ML.[dbo].[AssessmentPredictions_LinReg];
GO

CREATE TABLE ML.[dbo].[AssessmentPredictions_LinReg](
	[TotalAV_Predicted] [int] NULL,
	[TotalAV_Actual] [int] NULL,
	[ParcelId] [int] NULL,
	[Swis] [int] NULL,
	[Acres] [int] NULL,
	[Zip] [int] NULL
) ON [PRIMARY]
GO