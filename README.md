# cloudera-hadoop-terraform-aws
Deploy in 15min a Cloudera Hadoop Cluster on AWS with Terraform

### Dependencies
- AWS account
- AWS IAM credentials with ec2 and volumes access
- Terraform (https://www.terraform.io/downloads.html)
- Security group with this configurations:
  - All traffic only for your IP;
  - All traffic only for security group name;
  - SSH for your IP.
  - All ICMP - IPv4 only for security group.
  
### Configure
- open `main.tf` file and:
    - fill `access_key` and `secret_key` with your AWS credentials.
    - change `security_groups` in all machines.

### Create Clouder Hadoop Cluster
Run in project folder `terraform apply`.

### Enter in Cloudera mananger
Open in your browser `http://{hadoop-master-1 IP or hostname}:7180`
