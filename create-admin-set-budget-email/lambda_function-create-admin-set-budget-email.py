# File: lambda_function.py

# This Python file contains the Lambda function code for automating following tasks:

# The lambda_handler function, which is the entry point for the Lambda function.
# Sets up AWS clients for IAM and Budgets services.
# Creates an administrator user with the specified name and password.
# Attaches the AdministratorAccess policy to the administrator user.
# Sets up a monthly cost budget with email notifications when the actual costs exceed 80% of the budget amount.
# Outputs the administrator user name and the login URL for the AWS Management Console.
# Returns a response with a success message.

# To use this Lambda function, you'll need to create a new Lambda function in your AWS account, 
# upload this lambda_function.py file as the function code, and configure the necessary permissions 
# and environment variables (if any).


import boto3

def lambda_handler(event, context):
    # Set up AWS clients
    iam = boto3.client('iam')
    budgets = boto3.client('budgets')

    # Create an administrator user
    admin_user_name = 'admin-user'
    admin_user_password = 'YOUR_SECURE_PASSWORD'

    create_user_response = iam.create_user(
        UserName=admin_user_name
    )

    iam.create_login_profile(
        UserName=admin_user_name,
        Password=admin_user_password,
        PasswordResetRequired=True
    )

    iam.attach_user_policy(
        UserName=admin_user_name,
        PolicyArn='arn:aws:iam::aws:policy/AdministratorAccess'
    )

    # Set up a cost budget with notifications
    budget_amount = 100
    budget_email = 'your-budget-email@example.com'

    budgets.create_budget(
        AccountId=boto3.client('sts').get_caller_identity()['Account'],
        Budget={
            'BudgetName': 'Monthly-Cost-Budget',
            'BudgetType': 'COST',
            'TimeUnit': 'MONTHLY',
            'BudgetLimit': {
                'Amount': budget_amount,
                'Unit': 'USD'
            }
        },
        NotificationsWithSubscribers=[
            {
                'Notification': {
                    'ComparisonOperator': 'GREATER_THAN',
                    'NotificationType': 'ACTUAL',
                    'Threshold': 80,
                    'ThresholdType': 'PERCENTAGE'
                },
                'Subscribers': [
                    {
                        'SubscriptionType': 'EMAIL',
                        'Address': budget_email
                    }
                ]
            }
        ]
    )

    # Output the admin user name and login URL
    print(f"Admin user name: {admin_user_name}")
    print(f"Admin user login URL: https://{boto3.client('sts').get_caller_identity()['Account']}.signin.aws.amazon.com/console")

    return {
        'statusCode': 200,
        'body': 'Day 1 activities completed successfully.'
    }