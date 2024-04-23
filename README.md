# Terraform CI/CD Workspace

This Terraform workspace configures an AWS-based CI/CD environment using Cloud9, CodePipeline, CodeBuild, and additional resources. It sets up CodeCommit as the version control service to manage and automatically trigger builds from changes in the repository.

## Prerequisites

Before you begin, ensure you have the following installed and configured:

- **Terraform**: Version 0.12.x or later. Download from [Terraform.io](https://www.terraform.io/downloads.html).
- **AWS CLI**: Configured with administrative access to your AWS account. See [AWS CLI Installation Guide](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html).

## Quick Start

Follow these steps to set up your CI/CD environment:

1. **If you have not already created an S3 bucket and DynamoDB table for this environment, you can use the tf code in the `bootstrap` folder to do this.  TF state created by this action is meant to be commited to a version of this repository in your environment for later reference or management.  

    Modify the variables at `bootstrap/terraform.tfvars` to meet the needs of the given account you are bootstrapping.  You can then run a tf apply:
    ```
    cd bootstrap
    vi terraform.tfvars
    terraform init && terraform apply
    cd ..
    ```
    After running apply, one of the outputs is a backend block that can be used in the pipeline terraform.  The output should look like this:

    ```hcl
    backend "s3" {
        bucket         = "dtns-devtest-tf-state-us-east-1"
        key            = "state/tf-pipeline/terraform.tfstate"
        dynamodb_table = "tf-state-dtnsdevtest-us-east-1"
        region         = "us-east-1"
        encrypt        = "true"
    }
    ```
    That snippet would go inside your `terraform {}` stanza at `main.tf` and then the state for this codepipeline would be stored and tracked in that bucket.

2. **Update the `terraform.tfvars` file** located in the repo root directory with your environment specifics:
    ```
    nano terraform.tfvars
    ```

3. **Initialize Terraform** to download the necessary plugins and prepare your workspace, then run a plan:
    ```
    terraform init && terraform plan
    ```

4. **Apply the Terraform configuration** to create the resources:
    ```
    terraform apply
    ```

5. **Upload the `repo-template` content** to your newly created CodeCommit repository, which will kick off the CI/CD pipeline.  There will be a Cloud9 IDE created as part of this Terraform module that you can use to do this.  The IDE's owner will be set as  

## What This Does

This Terraform configuration will set up the following:

- **AWS Cloud9 Environment**: An IDE for writing, running, and debugging your code.
- **AWS CodePipeline**: A continuous integration and continuous delivery service for fast and reliable application and infrastructure updates.
- **AWS CodeBuild**: A service that compiles source code, runs tests, and produces software packages that are ready to deploy.
- **CodeCommit Repository**: A source control service to host your private git repositories.

## List of resources created

| Module                                         | Resource Type                                    | Resource Name                           |
|------------------------------------------------|--------------------------------------------------|-----------------------------------------|
| module.cloud9_ide                              | aws_cloud9_environment_ec2                       | cloud9_env                              |
| module.cloud9_ide                              | aws_iam_policy                                   | codecommit_access                       |
| module.cloud9_ide                              | aws_iam_role                                     | cloud9_role                             |
| module.cloud9_ide                              | aws_iam_role_policy_attachment                   | codecommit_policy_attach                |
| module.codebuild_terraform                     | aws_codebuild_project                            | terraform_codebuild_project             |
| module.codecommit_infrastructure_source_repo   | aws_codecommit_approval_rule_template            | source_repository_approval              |
| module.codecommit_infrastructure_source_repo   | aws_codecommit_approval_rule_template_association| source_repository_approval_association  |
| module.codecommit_infrastructure_source_repo   | aws_codecommit_repository                        | source_repository                       |
| module.codepipeline_iam_role                   | aws_iam_policy                                   | codepipeline_policy                     |
| module.codepipeline_iam_role                   | aws_iam_role                                     | codepipeline_role                       |
| module.codepipeline_iam_role                   | aws_iam_role_policy_attachment                   | codepipeline_role_attach                |
| module.codepipeline_kms                        | aws_kms_key                                      | encryption_key                          |
| module.codepipeline_terraform                  | aws_codepipeline                                 | terraform_pipeline                      |
| module.s3_artifacts_bucket                     | aws_s3_bucket                                    | codepipeline_bucket                     |
| module.s3_artifacts_bucket                     | aws_s3_bucket                                    | replication_bucket                      |
| module.s3_artifacts_bucket                     | aws_s3_bucket_logging                            | codepipeline_bucket_logging             |
| module.s3_artifacts_bucket                     | aws_s3_bucket_logging                            | replication_bucket_logging              |
| module.s3_artifacts_bucket                     | aws_s3_bucket_policy                             | bucket_policy_codepipeline_bucket       |
| module.s3_artifacts_bucket                     | aws_s3_bucket_policy                             | bucket_policy_replication_bucket        |
| module.s3_artifacts_bucket                     | aws_s3_bucket_public_access_block                | codepipeline_bucket_access              |
| module.s3_artifacts_bucket                     | aws_s3_bucket_public_access_block                | replication_bucket_access               |
| module.s3_artifacts_bucket                     | aws_s3_bucket_replication_configuration          | replication_config                      |
| module.s3_artifacts_bucket                     | aws_s3_bucket_server_side_encryption_configuration | codepipeline_bucket_encryption        |
| module.s3_artifacts_bucket                     | aws_s3_bucket_server_side_encryption_configuration | replication_bucket_encryption         |
| module.s3_artifacts_bucket                     | aws_s3_bucket_versioning                         | codepipeline_bucket_versioning          |
| module.s3_artifacts_bucket                     | aws_s3_bucket_versioning                         | replication_bucket_versioning           |
