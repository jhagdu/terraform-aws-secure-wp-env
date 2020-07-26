# terraform-aws-secure-wp-env
This Repository Contains Terraform Code which Create Secure AWS Infrastructure for Deploying WordPress with MySQL Database

# Usage
First Download or Clone this repo to your local system  
After this,  
To Initiate Terraform WorkSpace       :- terraform init  
To create infrastructure, run command :- terraform apply -auto-approve  
To delete infrastructure, run command :- terraform destroy -auto-approve  

# Prerequisites
1) Terraform should be Installed  
2) AWS CLI should be Installed  
3) In AWS CLI make a profile named tflogin  
   - command to create profile :- aws configure --profile tflogin  
   OR  
   - If you don't want to create profile then go into Infrastructure.tf file and change profile name to any of your pre-created profile
