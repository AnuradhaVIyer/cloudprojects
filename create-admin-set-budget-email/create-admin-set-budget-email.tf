# File: create-admin-set-budget-email.tf
# Author: Anuradha Iyer

# This Terraform configuration file defines the resources and variables required for automating tasks in a new AWS account.

# Configures the AWS provider with the desired region.
# Defines input variables for the administrator user name, email, budget amount, and budget email.
# Creates an IAM user with the specified name and attaches the AdministratorAccess policy.
# Sets up an AWS Budget with a monthly cost budget limit and configures email notifications when the actual costs exceed 80% of the budget.
# Outputs the administrator user name and the login URL for the AWS Management Console.

# To use this Terraform configuration, you'll need to have Terraform installed and configured with your AWS credentials.
# Additionally, you'll need to provide values for the input variables, either through a terraform.tfvars file 
# or by passing them as command-line arguments.

# Configure the AWS provider
provider "aws" {
  region = "us-east-1" # Replace with your desired region
}

# Input variables
variable "admin_user_name" {
  description = "Name for the administrator user"
  type        = string
}

variable "admin_user_email" {
  description = "Email address for the administrator user"
  type        = string
}

variable "budget_amount" {
  description = "Monthly budget amount in USD"
  type        = number
}

variable "budget_email" {
  description = "Email address to receive budget notifications"
  type        = string
}

# Resource: Create an administrator user
resource "aws_iam_user" "admin_user" {
  name = var.admin_user_name
  path = "/"
}

# Resource: Attach the AdministratorAccess policy to the admin user
resource "aws_iam_user_policy_attachment" "admin_policy_attachment" {
  user       = aws_iam_user.admin_user.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Resource: Set up a cost budget with notifications
resource "aws_budgets_budget" "monthly_cost_budget" {
  name              = "Monthly-Cost-Budget"
  budget_type       = "COST"
  limit_amount      = var.budget_amount
  limit_unit        = "USD"
  time_period_start = formatdate("YYYY-MM-DD_00:00", timestamp())
  time_unit         = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 80
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = [var.budget_email]
  }
}

# Output the admin user name and login URL
output "admin_user_name" {
  value       = aws_iam_user.admin_user.name
  description = "Administrator user name"
}

output "admin_user_login_url" {
  value       = "https://${data.aws_caller_identity.current.account_id}.signin.aws.amazon.com/console"
  description = "URL for the administrator user to log in to the AWS Management Console"
}
