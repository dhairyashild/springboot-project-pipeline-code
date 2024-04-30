
pipeline {
    environment{
        AWS_ACCESS_KEY_ID=credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY=credentials('AWS_SECRET_ACCESS_KEY')
        region= "ap-south-1"
    }
    agent {
        label 'worker'
    }
    tools {
        maven "maven"
        // docker "docker"
    }
    stages {
//         stage("clone") {
//             steps {
// checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/dhairyashild/springboot-java-poject-small-devopsshack-copy.git']])       
//                     }
//         }
//         stage("build") {
//             steps {
//                 dir ('/home/ubuntu/jenkins/workspace/springboot-project-pipeline-code/'){
//                 sh 'mvn clean install'
//                 }
                    
//                 }
//         }
        
//         stage("sonar") {
//             steps {
//               sh '''mvn clean verify sonar:sonar \
//   -Dsonar.projectKey=springboot-project-pipeline-code \
//   -Dsonar.host.url=http://52.66.197.219:9000 \
//   -Dsonar.login=sqp_301a5ec1a74ece60154cffdba037544a0ebc0671'''    
//                 }
                    
//                 }


  

// stage ('ecr push'){
//     steps{
//         sh 'aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/d8y1d3c0'
        
//          sh 'docker build -t spring-app .'
        
//          sh 'docker tag spring-app:latest public.ecr.aws/d8y1d3c0/spring-app:latest'
         
//          sh 'docker push public.ecr.aws/d8y1d3c0/spring-app:latest'
//     }
// }

stage("terraform clone repo") {
            steps {
               checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/dhairyashild/springboot-project-pipeline-code.git']])
                }
      
                }

      stage("terraform init") {
            steps {
                dir ('CONTINEOUS-DEPLOYMENT'){
                sh 'terraform init'
                }
            }
                }
                
                 stage("terraform fmt") {
            steps {
                dir ('CONTINEOUS-DEPLOYMENT'){
                sh 'terraform fmt'
                }
            }
                }
                
                 stage("terraform plan") {
            steps {
                dir ('CONTINEOUS-DEPLOYMENT'){
                sh 'terraform plan'
                
                }
            }
                }
          
            //       stage("terraform apply") {
            // steps {
            //     dir ('CONTINEOUS-DEPLOYMENT'){
            //     sh 'terraform apply --auto-approve'
                
            //     }
            // }
            //     } 
            stage("set context") {
            steps {
                sh 'aws eks update-kubeconfig --region ap-south-1 --name example'
                sh 'kubectl create namespace workshop'
            
            }
                }
                
                      stage('create service account') {
            steps {
              
               sh 'curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.5.4/docs/install/iam_policy.json'
                sh 'aws iam create-policy --policy-name AWSLoadBalancerControllerIAMPolicy --policy-document file://iam_policy.json'
                sh 'eksctl utils associate-iam-oidc-provider --region=ap-south-1 --cluster=example --approve'
                sh 'eksctl create iamserviceaccount --cluster=example --namespace=kube-system --name=aws-load-balancer-controller --role-name AmazonEKSLoadBalancerControllerRole --attach-policy-arn=arn:aws:iam::103849455660:policy/AWSLoadBalancerControllerIAMPolicy --approve --region=ap-south-1'
                
            }
                }
                
                 stage("install aws load balancer controller") {
            steps {
                sh 'sudo snap install helm --classic'
                sh 'helm repo add eks https://aws.github.io/eks-charts'
             sh 'helm repo update eks' 
             sh 'helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system --set clusterName=my-cluster --set serviceAccount.create=false --set serviceAccount.name=aws-load-balancer-controller'
             
             sh 'kubectl get deployment -n kube-system aws-load-balancer-controller'
             sh 'kubectl apply -f kubernates_manifest'
            }
                } 
            
        }
}


    
