## Testing against AWS ("nomock")

These tests are designed to be run in an account where AWS Config has
NOT been enabled. If the AWS Config is enabled, then the supporting 
resources used by the tests will already exist and the tests will fail.

Therefore, use an AWS profile that does not have AWS Config enabled to 
run the test against AWS. Set the environment variable `AWS_PROFILE` and
run the tests from the repo's root directory as follows:

`make terraform/pytest PYTEST_ARGS="--nomock"`
