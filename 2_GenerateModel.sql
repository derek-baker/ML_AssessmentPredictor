USE Parcel56

-- NOTE: Standard Python indentation rules must be observer
-- Stored procedure that trains and generates a Python model using data and a decision tree algorithm
DROP PROCEDURE IF EXISTS usp_GenerateAssessmentPyModel;
GO

CREATE PROCEDURE usp_GenerateAssessmentPyModel(@trained_model varbinary(max) OUTPUT)
AS
BEGIN
    EXECUTE sp_execute_external_script
        @language = N'Python'
        ,@script = N'
from sklearn.linear_model import LinearRegression
import pickle

df = assessment_training_data

# Get all the columns from the dataframe.
columns = df.columns.tolist()

# Store the variable well be predicting on.
target = "TotalAV"

# Initialize the model class.
lin_model = LinearRegression()

# Fit the model to the training data.
lin_model.fit(df[columns], df[target])

# Before saving the model to the DB table, convert it to a binary object
trained_model = pickle.dumps(lin_model)'

        ,@input_data_1 = N'SELECT TotalAV, ParcelId, Swis, Acres, Zip FROM Parcel56.dbo.CleanedAssessmentDataForTraining'
        ,@input_data_1_name = N'assessment_training_data'
        ,@params = N'@trained_model varbinary(max) OUTPUT'
        ,@trained_model = @trained_model OUTPUT;

END;

GO