## create-admin-set-budget-email

This repository contains various templates and scripts for automating tasks in a new AWS account. The template creates an administrator user, attaches the AdministratorAccess policy, and sets up a monthly cost budget with email notifications.

## Prerequisites

Before using this the templates and scripts, ensure that you have:

- An AWS account
- AWS CLI or AWS Management Console access

## Cloudformation

## Usage

1. Clone this repository or download the `create-admin-set-budget-email.yaml` file.

2. Open the AWS CloudFormation console or use the AWS CLI to create a new stack.

3. When prompted, provide the following parameters:

   - `AdminUserName`: The desired username for the administrator user.
   - `AdminUserEmail`: The email address associated with the administrator user.
   - `BudgetAmount`: The monthly budget amount in USD.
   - `BudgetEmail`: The email address to receive budget notifications.

4. Review and create the stack.

5. After the stack creation is complete, note the `AdminUserName` and `AdminUserLoginURL` outputs.

6. **Manually activate MFA for the root user account.** This step cannot be automated and must be performed by the root user following AWS documentation.

## Resources Created

This CloudFormation template creates the following resources:

- `AWS::IAM::User`: An IAM user with the specified name and the AdministratorAccess policy attached.
- `AWS::Budgets::Budget`: An AWS Budget with a monthly cost budget limit and email notifications for exceeding 80% of the limit.

## Security Considerations

- The administrator user is created with the AdministratorAccess policy, granting full access to AWS resources. Use this user responsibly and follow the principle of least privilege when possible.
- MFA for the root user account is not enabled by this template and must be manually activated by the root user.
- Review and adjust the budget amount and notification threshold as per your requirements.

## Cleanup

To delete the resources created by this CloudFormation stack, delete the stack from the AWS CloudFormation console or using the AWS CLI.

## Other templates and scripts

Follow steps or dependencies for other templates or scripts before executing them.
