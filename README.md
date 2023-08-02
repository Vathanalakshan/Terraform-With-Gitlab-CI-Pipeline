# Terraform-With-Gitlab-CI-Pipeline

<img width="603" alt="image" src="https://user-images.githubusercontent.com/28689837/235117719-5dec9913-74c9-46d7-847a-87da5a3621d0.png">

## Overview

In this personal project, I used Terraform and GitLab CI/CD to deploy and manage resources on AWS. I set up a GitLab Runner on my local computer and configured GitLab Secrets to store my AWS credentials. The runner is able to automatically create, format, validate, and plan. However, applying and destroying resources require manual intervention. The Terraform state is also managed by GitLab, enabling remote planning, applying, and destroying of AWS resources.
