# Integrate Terraform and Ansible in Jenkins pipelines

## Terraform pipeline

Use `16_terraform_workspace/terraform.Jenkinsfile` as skeleton, design a Jenkins pipeline provision infrastructure using Terraform.
The pipeline should be env- and region-agnostic. 


## Ansible pipeline

Use `17_ansible_workdir/ansible.Jenkinsfile` as skeleton, design a Jenkins pipeline that runs Ansible playbooks.
The pipeline should dynamically load server IP based on an `serverGroup` tag on each EC2 instance, which indicates the hosts group that the server belongs to. 
Write some Python script that will help you to parse the data and generate Ansible inventory file. 

