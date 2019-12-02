USE ML

-- NOTE: Standard Python indentation rules must be observed
-- PURPOSE: Train and generates a Python model using data and a decision tree algorithm
-- RETURNS: Uses OUTPUT param to make changes to param visible to caller.
DROP PROCEDURE IF EXISTS dbo.usp_GenerateAssessmentPyMultiValLinearModel;
GO

CREATE PROCEDURE dbo.usp_GenerateAssessmentPyMultiValLinearModel(@trained_model varbinary(max) OUTPUT)
AS
BEGIN
    EXECUTE sp_execute_external_script
        @language = N'Python'
        ,@script = N'
from sklearn.linear_model import LinearRegression
import pickle

# Note that assessment training data was passed into the sproc via @input_data_1_name
df = assessment_training_data

column_names_list = df.columns.tolist()

prediction_target = "TotalAV"

linear_regression_model = LinearRegression()

linear_regression_model.fit(df[column_names_list], df[prediction_target])

# Note that trained_model will be visible to the caller via @trained_model
trained_model = pickle.dumps(linear_regression_model)'

        ,@input_data_1 = N'SELECT * FROM ML.dbo.AssessmentTrainingDataMultiVarLinReg'
        ,@input_data_1_name = N'assessment_training_data'
        ,@params = N'@trained_model varbinary(max) OUTPUT'
        ,@trained_model = @trained_model OUTPUT;

END;

GO