pipeline {
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        region = "ap-south-1"
    }
    agent {
        label 'worker'
    }
    tools {
        maven "maven"
    }
    stages {
        stage("clone") {
            steps {
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/dhairyashild/springboot-project-pipeline-code.git']])
            }
        }
        stage("build") {
            steps {
                dir('/home/ubuntu/jenkins/workspace/springboot-project-pipeline-code/') {
                    sh 'mvn clean install'
                }
            }
        }
        stage("sonar") {
            steps {
                sh '''mvn clean verify sonar:sonar \
  -Dsonar.projectKey=eks-proect \
  -Dsonar.host.url=http://3.108.221.108:9000 \
  -Dsonar.login=sqp_cb72a0b72bc885c243c332979839cb36d97c4bc6'''
            }
        }
        stage('ecr push') {
            steps {
                sh 'aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/d8y1d3c0'
                sh 'docker build -t spring-app .'
                sh 'docker tag spring-app:latest public.ecr.aws/d8y1d3c0/spring-app:latest'
                sh 'docker push public.ecr.aws/d8y1d3c0/spring-app:latest'
            }
        }
      
        stage("terraform init") {
            steps {
                dir('CONTINEOUS-DEPLOYMENT') {
                    sh 'terraform init'
                }
            }
        }
        stage("terraform fmt") {
            steps {
                dir('CONTINEOUS-DEPLOYMENT') {
                    sh 'terraform fmt'
                }
            }
        }
        stage("terraform plan") {
            steps {
                dir('CONTINEOUS-DEPLOYMENT') {
                    sh 'terraform plan'
                }
            }
        }
        stage("terraform apply") {
            steps {
                dir('CONTINEOUS-DEPLOYMENT') {
                    sh 'terraform apply --auto-approve'
                }
            }
        }
        stage("set context") {
            steps {
                sh 'aws eks update-kubeconfig --region ap-south-1 --name my-cluster'
                sh 'kubectl create namespace workshop'
            }
        }
        stage('create service account') {
            steps {
                sh 'chmod 777 aws-lb-controller.sh'
                sh './aws-lb-controller.sh'
            }
        }
        stage('apply manifest files') {
            steps {
                sh 'kubectl apply -f kubernates_manifest'
            }
        }
    }
}
