USE ML

-- NOTE: Standard Python indentation rules must be observed
DROP PROCEDURE IF EXISTS usp_PredictAssessmentWithLinReg;
GO
CREATE PROCEDURE usp_PredictAssessmentWithLinReg (@model varchar(100))
AS
BEGIN
	DECLARE @py_model varbinary(max) = (SELECT model FROM ML.dbo.AssessmentPyLinRegModels WHERE model_name = @model);

	EXEC sp_execute_external_script
				@language = N'Python',
				@script = N'
from sklearn.metrics import mean_squared_error
import pickle
import pandas as pd

assessment_model = pickle.loads(py_model)

df = assessment_score_data

# Generate the predictions for the test set.
linear_predictions = assessment_model.predict(df["Sqft"].values.reshape(-1,1))
predictions_df = pd.DataFrame(linear_predictions)


# Compute error between the test predictions and the actual values.
error = mean_squared_error(df["TotalAV"], linear_predictions)
print(error)

predictions_df["MeanSquaredErr"] = error


OutputDataSet = pd.concat([predictions_df, df["TotalAV"], df["ConditionCode"], df["Sqft"], df["NumBaths"], df["NumBedrooms"], df["Age"]], axis=1)
'

,@input_data_1 = N'SELECT * FROM ML.dbo.AssessmentTestingDataLinReg'
,@input_data_1_name = N'assessment_score_data'
,@params = N'@py_model varbinary(max)'
,@py_model = @py_model
WITH result SETS((
    "TotalAV_Predicted" int,
    "MeanSquaredErr" nvarchar(100),
    "TotalAV" int,
    "ConditionCode" int,
    "Sqft" int,
    "NumBaths" int,
    "NumBedrooms" int,
    "Age" int
));

END;
GO