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
checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/dhairyashild/java-springboot-code.git']])            }
        }
        
        stage("build") {
            steps {
                dir('/home/ubuntu/jenkins/workspace/springboot-project-pipeline-code/java-springboot-code') {
                    sh 'mvn clean install'
                }
            }
        }
        
      stage('SonarQube Analysis') {
    def mvn = tool 'Default aven';
    withSonarQubeEnv() {
      sh "${mvn}/bin/mvn clean verify sonar:sonar -Dsonar.projectKey=java-project"
    }
  }
        
        stage('ecr push') {
            steps {
                dir('/home/ubuntu/jenkins/workspace/springboot-project-pipeline-code/java-springboot-code') {
                sh 'aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/d8y1d3c0'
                sh 'docker build -t spring-app .'
                sh 'docker tag spring-app:latest public.ecr.aws/d8y1d3c0/spring-app:latest'
                sh 'docker push public.ecr.aws/d8y1d3c0/spring-app:latest'
                }
            }
        }
      
stage("clone-terraform-code") {
            steps {
checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/dhairyashild/springboot-project-pipeline-code.git']])        
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
                    sh 'terraform $ACTION --auto-approve'
                }
            }
        }
    }
}
