USE Parcel56

--Insert the results of the predictions for test set into a table
TRUNCATE TABLE dbo.AssessmentPredictions
INSERT INTO AssessmentPredictions
EXEC usp_PredictAssessment 'linear_model';

-- Select contents of the table
SELECT * FROM AssessmentPredictions;