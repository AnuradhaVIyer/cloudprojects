#!/bin/bash

# File: create-admin-set-budget-email.sh
# Author: Anuradha Iyer

# This Bash script automates tasks using the AWS CLI on Linux or macOS systems.


# Creates an administrator user with the specified name and password.
# Attaches the AdministratorAccess policy to the administrator user.
# Sets up a monthly cost budget with email notifications when the actual costs exceed 80% of the budget amount.
# Outputs the administrator user name and the login URL for the AWS Management Console.

# To run this Bash script, you'll need to have the AWS CLI installed and configured on your system.
# You may need to replace YOUR_SECURE_PASSWORD and your-budget-email@example.com with the desired values.

# Create an administrator user
admin_user_name="admin-user"
admin_user_password="YOUR_SECURE_PASSWORD"

aws iam create-user --user-name "$admin_user_name"
aws iam create-login-profile --user-name "$admin_user_name" --password "$admin_user_password" --password-reset-required

aws iam attach-user-policy --user-name "$admin_user_name" --policy-arn "arn:aws:iam::aws:policy/AdministratorAccess"

# Set up a cost budget with notifications
budget_amount=100
budget_email="your-budget-email@example.com"

aws budgets create-budget \
    --account-id "$(aws sts get-caller-identity --query 'Account' --output text)" \
    --budget '{"BudgetName": "Monthly-Cost-Budget", "BudgetType": "COST", "TimeUnit": "MONTHLY", "BudgetLimit": {"Amount": '${budget_amount}', "Unit": "USD"}}' \
    --notifications-with-subscribers '[{"Notification": {"ComparisonOperator": "GREATER_THAN", "NotificationType": "ACTUAL", "Threshold": 80, "
