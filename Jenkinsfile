pipeline {
    agent any
    
    environment {
        PRIVATE_KEY = credentials('host_key')
        DOCKERHUB_CRED = credentials('moatazxz_dockerhub')
        DOCKER_HOST_SERVER = 'ec2-user@54.80.0.85'
        DOCKER_UER='moatazxz'
    }
    
  tools {
        maven 'maven_3.9.6' 
    }
    

    stages {
        
        stage('Build') {
            steps {
                // Run Maven build command
                sh """
                  cd ./app
                  ls 
                  mvn clean install
                  docker build -t ${DOCKER_UER}/hello-world-mvn:lts .
                """
            }
        }
        
        stage('Push docker image to docker-hub') {
            steps {
                // Run Push docker Image
                sh """
                 echo ${DOCKERHUB_CRED_PSW} | docker login -u ${DOCKER_UER}  --password-stdin
                 docker push  ${DOCKER_UER}/hello-world-mvn:lts
                """
            }
        }
        
        
        
        stage('deploy') {
            steps {
            sshagent(['host_key']) {
               sh """
                 
                ssh -o StrictHostKeyChecking=no ${DOCKER_HOST_SERVER} '
                echo ${DOCKERHUB_CRED_PSW} | docker login -u ${DOCKER_UER}  --password-stdin
                '
                
                ssh -o StrictHostKeyChecking=no ${DOCKER_HOST_SERVER} '
                docker run -d  -p 8080:8080 ${DOCKER_UER}/hello-world-mvn:lts
                '

            """
            }
        }
    }
}
    
}
