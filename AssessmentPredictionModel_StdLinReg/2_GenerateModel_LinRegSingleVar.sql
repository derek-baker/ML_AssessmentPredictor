USE ML

-- NOTE: Standard Python indentation rules must be observed
-- PURPOSE: Train and effectively return a linear regression model(serialized to binary)
DROP PROCEDURE IF EXISTS dbo.usp_GenerateAssessmentPyLinearModel;
GO

CREATE PROCEDURE dbo.usp_GenerateAssessmentPyLinearModel(@trained_model varbinary(max) OUTPUT)
AS
BEGIN
    EXECUTE sp_execute_external_script
        @language = N'Python'
        ,@script = N'
from sklearn.linear_model import LinearRegression
import pickle

# The var below was "passed in" to this procedure as @input_data_1 (see sproc params)
df = assessment_training_data

linear_regression_model = LinearRegression()

x_train = df["Acres"].values.reshape(-1,1)
y_train = df["TotalAV"]

linear_regression_model.fit(x_train, y_train)

# Convert model to a binary object (@trained model is basically passed in by reference)
trained_model = pickle.dumps(linear_regression_model)'

        ,@input_data_1 = N'SELECT TotalAV, ParcelId, Swis, Acres, Zip FROM ML.dbo.AssessmentTrainingDataLinReg'
        ,@input_data_1_name = N'assessment_training_data'
        ,@params = N'@trained_model varbinary(max) OUTPUT'
        ,@trained_model = @trained_model OUTPUT;

END;

GO