# TF_Kubernetes-cluster_ec2
Creating a 3 node Kubernetes cluster by provisioning EC2 instances with Terraform.

Configure AWS Credentials
1. Install aws-cli on your system.
> https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
2. Configure the AWS Credentials in aws-cli.
```aws configure```

Clone Git Repository

3. Clone the Git Repository.
```git clone https://github.com/anilbhuvan/TF_Kubernetes-cluster_ec2.git```
4. Launch the terminal and navigate to cloned git repository on your loacl system.

Install Terraform
> https://developer.hashicorp.com/terraform/downloads

5. ```terraform init```
6. ```terraform apply -auto-approve```

Applying this Terraform file will create one k8s-controller and two worker nodes in your AWS. PEM Key for the Instaces will be automatically downloaded in the local repository.

7. login to AWS console
8. SSH into K8s-Controller 

SSH key should be downloaded in your local repository during terraform apply process. Wait untill the "congigured-100%" file apperes in /home/ubuntu.

9. ```cat join_command.txt``` and copy the command.

10. SSH into k8s-worker1, and execute the join command copied in step 10

11. SSH into k8s-worker2, and execute the join command copied in step 10

12. SSH into K8s-Controller, and Get the list of all the nodes in the cluster 
```kubectl get nodes```

Kubernetes cluster is UP and Running!!!
