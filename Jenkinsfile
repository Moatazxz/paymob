pipeline {
    agent any
    
    environment {
        PRIVATE_KEY = credentials('docker-ssh')
        DOCKER_HOST_INSTANCE_IP = '54.172.211.134'
    }
    
  tools {
        maven 'maven_3.9.6' 
    }
    

    stages {
        
        stage('Build') {
            steps {
                // Run Maven build command
                sh 'mvn -v'
            }
        }
        
        
        
        stage('deploy') {
            steps {
            sshagent(['docker-ssh']) {
               sh """
                ssh -o StrictHostKeyChecking=no ec2-user@${EC2_INSTANCE_IP} '
                docker run -d --name myapp -p 80:80 nginx
                '
            """
            }
        }
    }
}
    
}
