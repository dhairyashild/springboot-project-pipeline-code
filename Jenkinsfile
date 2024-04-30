
pipeline {
    agent {
        label 'worker'
    }
    tools {
        maven "maven"
        // docker "docker"
    }
    stages {
        stage("clone") {
            steps {
checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/dhairyashild/springboot-java-poject-small-devopsshack-copy.git']])       
                    }
        }
        stage("build") {
            steps {
                dir ('/home/ubuntu/jenkins/workspace/eks-project-full-cicd/'){
                sh 'mvn clean install'
                }
                    
                }
        }
        
        stage("sonar") {
            steps {
              sh '''mvn clean verify sonar:sonar \
  -Dsonar.projectKey=springboot-project-pipeline-code \
  -Dsonar.host.url=http://52.66.197.219:9000 \
  -Dsonar.login=sqp_301a5ec1a74ece60154cffdba037544a0ebc0671'''    
                }
                    
                }


                   stage('Building image') {
      steps{
        script {
          dockerImage = docker.build registry
        }
      }
    }



      
       
                
        }
}


    
