
-- NOTE: Standard Python indentation rules must be observed
DROP PROCEDURE IF EXISTS usp_PredictAssessment;
GO
CREATE PROCEDURE usp_PredictAssessment (@model varchar(100))
AS
BEGIN
	DECLARE @py_model varbinary(max) = (SELECT model FROM ML.dbo.AssessmentPyModelsMultiVarLinReg WHERE model_name = @model);

	EXEC sp_execute_external_script
				@language = N'Python',
				@script = N'
# Import the scikit-learn function to compute error.
from sklearn.metrics import mean_squared_error
import pickle
import pandas as pd

assessment_model = pickle.loads(py_model)

df = assessment_score_data

# Get all the columns from the dataframe.
columns = df.columns.tolist()

# Variable you will be predicting on.
target = "TotalAV"

# Generate the predictions for the test set.
lin_predictions = assessment_model.predict(df[columns])
print(lin_predictions)

# Compute error between the test predictions and the actual values.
lin_mse = mean_squared_error(lin_predictions, df[target])
#print(lin_mse)

predictions_df = pd.DataFrame(lin_predictions)

OutputDataSet = pd.concat([predictions_df, df["TotalAV"], df["ParcelId"], df["Swis"], df["Acres"], df["Zip"]], axis=1)
'
,@input_data_1 = N'SELECT TotalAV, ParcelId, Swis, Acres, Zip FROM Parcel56.dbo.CleanedAssessmentData'
,@input_data_1_name = N'assessment_score_data'
,@params = N'@py_model varbinary(max)'
,@py_model = @py_model
WITH result SETS ((
    "TotalAV_Predicted" float,
    "TotalAV" int,
    "ParcelId" int,
    "Swis" int,    
    "Acres" int,
    "Zip" int
));

END;
GO