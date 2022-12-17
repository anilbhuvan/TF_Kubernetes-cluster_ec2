# TF_Kubernetes-cluster_ec2
Creating a 3 node Kubernetes cluster by provisioning EC2 instances with Terraform.

Basic Steps to provision the infrastructure
1. Install the AWS cli on your system 
> https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
2. Configure the AWS CLI credentials.
```aws configure```
3. clone the Git Repository
```git clone https://github.com/anilbhuvan/TF_Kubernetes-cluster_ec2.git```
4. Launch the terminal and navigate to the local repository
5. ```terraform init```
6. ```terraform apply -auto-approve```

Applying this Terraform file will create one k8s-controller and two worker nodes in your AWS,
PEM Key for the Instaces will be automatically downloaded in the local repository

7. login to aws console
8. SSH into K8s-Controller (ssh key should be downloaded in your loacl repository during terraform apply process)
9. wait untill the "congigured-100%" file apperes in /home/ubuntu
10. cat join_command.txt and copy the command.

SSH into k8s-worker1

11. execute the join command copied in step 10

SSH into k8s-worker2

12. execute the join command copied in step 10

SSH into K8s-Controller

13. Get the list of all nodes in the cluster ```kubectl get nodes```

Kubernetes cluster is UP and Running
