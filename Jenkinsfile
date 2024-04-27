pipeline {
    agent any
    
    environment {
        PRIVATE_KEY = credentials('host_key')
        DOCKER_HOST_INSTANCE_IP = '54.80.0.85'
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
                  docker build -t hello-world-mvn .
                """
                // sh 'cd ./app'
                // sh 'mvn clean install'
                // sh 'docker build -t hello-world-mvn .
            }
        }
        
        
        
        stage('deploy') {
            steps {
            sshagent(['host_key']) {
               sh """
                ssh -o StrictHostKeyChecking=no ec2-user@${EC2_INSTANCE_IP} '
                docker run -d --name myapp -p 80:80 hello-world-mvn
                '
            """
            }
        }
    }
}
    
}
