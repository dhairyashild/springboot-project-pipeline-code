#!/bin/bash

# Download IAM policy document
curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.5.4/docs/install/iam_policy.json

# # Create IAM policy
aws iam create-policy --policy-name AWSLoadBalancerControllerIAMPolicy --policy-document file://iam_policy.json

# # Associate IAM OIDC provider
eksctl utils associate-iam-oidc-provider --region=ap-south-1 --cluster=my-cluster --approve

# # Delete existing IAM service account
# eksctl delete iamserviceaccount --cluster=my-cluster --namespace=kube-system --name=aws-load-balancer-controller --region=ap-south-1

eksctl get iamserviceaccount --cluster=my-cluster
# eksctl create iamserviceaccount --cluster=my-cluster --namespace=kube-system --name=aws-load-balancer-controller --role-name AmazonEKSLoadBalancerControllerRole --attach-policy-arn=arn:aws:iam::103849455660:policy/AWSLoadBalancerControllerIAMPolicy --approve --region=ap-south-1
touch start.txt
sleep 200
# # Install Helm
sudo snap install helm --classic

# # Add Helm repository
helm repo add eks https://aws.github.io/eks-charts

# # Update Helm repositories
helm repo update

# # Install AWS Load Balancer Controller
helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system --set clusterName=my-cluster --set serviceAccount.create=false --set serviceAccount.name=aws-load-balancer-controller

# Check the deployment status
kubectl get deployment -n kube-system aws-load-balancer-controller
kubectl get po -n kube-system aws-load-balancer-controller
