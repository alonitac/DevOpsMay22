# CloudWatch alarms using Terraform

In this exercise you will implement as-a-code AWS CloudWatch alarms stack using Terraform.

## Background story

Your company runs services in AWS across 3 different regions.
The DevOps team manage a stack of 30 CloudWatch alarms for every region, which means, (3 regions) * (30 alarms) = 90 different alarms. 

Your task is to utilize Terraform to define and manage the alarms stack is reusable and consistent way across regions and environments. 

## Guidelines

Under `tf_alarm` directory you are given the following structure:

```text
tf_alarm/
├── alarams.Jenkinsfile
├── environments
│   ├── dev.tfvars
│   └── prod.tfvars
├── main.tf
├── outputs.tf
├── regions
│   ├── eu-central-1-prod.tfvars
│   ├── us-east-1-dev.tfvars
│   ├── us-east-1-prod.tfvars
│   └── us-west-1-prod.tfvars
└── variables.tf
```

- The `main.tf` file contains configurations of 3 CloudWatch alarms, as well as the `terraform` block with the relevant provider and an [S3 backend](https://developer.hashicorp.com/terraform/language/settings/backends/s3).  
  Note that the configurations of the alarms are completely env- and region-agnostic. They should keep this property. 

- `vairalbe.tf` and `output.tf` contain variable definitions and outputs. Feel free to modify if needed. 
- `environments` dir contains `.tfvars` files with per-env variable assignments. Put there values that might be relevant for an entire environment. For example, `env = prod`, this variable can be used as a name prefix for resources (`alarm1-${var.env}` will create `alarm1-dev` and `alarm2-prod` etc.). Another example is `sendMail = true`, use this variable when you want to disable/enable mailing for triggered alarms (by default you want to receive mails for production incidents, but don't want to get any mail for incidents in development env).  
- `regions` dir contains `.tfvars` files with per-region variable assignments. Put there relevant values for every region. For example, as the configured alarms deal with high CPU usage of a certain EC2 instance, the instanceID value of each monitored EC2 might be found in the relevant `.tfvars` file of each region.  
- `alarams.Jenkinsfile` is an almost ready-to-use Jenkinsfile to integrate the alarms pipeline in your Jenkins server. Do your modifications if needed.

In this exercise we assume that the `dev` environment is deployed in `us-east-1` only (no need to deploy dev in multiple regions), and `prod` environment is deployed in `us-east-1`, `us-west-1` and `eu-central-1`.
You'll provision 3 CloudWatch example alarms (`alarm1`, `alarm2`, `alarm3`) in every region of dev and prod, except `alarm3`, which should be provisioned in `us-east-1` **only**.

You should add to `main.tf` a resource definition for SNS topic to be used as an action channel when alarms are triggered. Note that we want to actually send mails only for triggered alarm in production. We don't want to bother the on-call team for alarms in dev. 
 
Use [Workspaces](https://developer.hashicorp.com/terraform/language/state/workspaces) to conveniently provision the alarms stack in multiple environments and regions.

Test your system in Jenkins and AWS. Deploy a change and let Jenkins provision the new configurations, test the alarm in action..

Optional - create another Jenkins pipeline that triggers the pipeline based on `alarams.Jenkinsfile` for every region in a given environment. 

# Good Luck
