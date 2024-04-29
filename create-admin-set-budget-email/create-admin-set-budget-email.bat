REM File: create-admin-set-budget-email.bat
REM Author: Anuradha Iyer

REM This batch file does the following:

REM Sets the AWS CLI profile (if needed) using the AWS_PROFILE environment variable.
REM Creates an administrator user with the specified name and password.
REM Attaches the AdministratorAccess policy to the administrator user.
REM Sets up a monthly cost budget with email notifications for exceeding 80% of the budget amount.
REM Outputs the administrator user name and the login URL for the AWS Management Console.
REM Displays a reminder to perform the manual steps of verifying account information and activating MFA for the root user.

REM Note:

REM Replace YOUR_SECURE_PASSWORD with a strong password for the administrator user.
REM Replace your-aws-profile with your desired AWS CLI profile name (if needed).
REM Replace your-budget-email@example.com with the email address to receive budget notifications.
REM File: create-admin-set-budget-email.bat

REM The >nul at the end of some commands suppresses the output.
REM The ^ character is used for line continuation in batch files.
REM Make sure to have the AWS CLI installed and configured on your Windows machine before running this batch file.


@echo off

REM Set AWS CLI profile (if needed)
set AWS_PROFILE=your-aws-profile

REM Create an administrator user
set admin_user_name=admin-user
set admin_user_password=YOUR_SECURE_PASSWORD

aws iam create-user --user-name %admin_user_name% >nul
aws iam create-login-profile --user-name %admin_user_name% --password %admin_user_password% --password-reset-required >nul
aws iam attach-user-policy --user-name %admin_user_name% --policy-arn "arn:aws:iam::aws:policy/AdministratorAccess" >nul

REM Set up a cost budget with notifications
set budget_amount=100
set budget_email=your-budget-email@example.com

aws budgets create-budget ^
    --account-id "%AWS_ACCOUNT_ID%" ^
    --budget "{\"BudgetName\": \"Monthly-Cost-Budget\", \"BudgetType\": \"COST\", \"TimeUnit\": \"MONTHLY\", \"BudgetLimit\": {\"Amount\": %budget_amount%, \"Unit\": \"USD\"}}" ^
    --notifications-with-subscribers "[{\"Notification\": {\"ComparisonOperator\": \"GREATER_THAN\", \"NotificationType\": \"ACTUAL\", \"Threshold\": 80, \"ThresholdType\": \"PERCENTAGE\"}, \"Subscribers\": [{\"SubscriptionType\": \"EMAIL\", \"Address\": \"%budget_email%\"}]}]" >nul

REM Output the admin user name and login URL
echo Admin user name: %admin_user_name%
echo Admin user login URL: https://%AWS_ACCOUNT_ID%.signin.aws.amazon.com/console

REM Manual steps
echo.
echo Please perform the following manual steps:
echo 1. Verify that your account information is accurate
echo 2. Activate MFA for your root user

pause
