USE Parcel56

DROP TABLE IF EXISTS [dbo].[AssessmentPredictions];
GO

CREATE TABLE [dbo].[AssessmentPredictions](
	[TotalAV_Predicted] [int] NULL,
	[TotalAV_Actual] [int] NULL,
	[ParcelId] [int] NULL,
	[Swis] [int] NULL,
	[Acres] [int] NULL,
	[Zip] [int] NULL
) ON [PRIMARY]
GO