pipeline {
    
    agent any
    
    environment {
        
        IMAGE_NAME = "dumalbhaskar/flask-app:${BUILD_NUMBER}"
    }

    stages {
        
        stage('checkout') {
            steps {
                
               git branch: 'main', url: 'https://github.com/DumalBhaskar/jenkins-project.git'
            }
        }
        
        stage('image-build') {
            steps {
                
                sh 'docker build -t ${IMAGE_NAME} .'
            }
        }
        
        stage('image-push') {
            steps {
                script{
                    
                     withDockerRegistry(credentialsId: 'docker-cred') {
                    
                        sh 'docker push ${IMAGE_NAME}'
                    
                    }
                }
               
            }
        }
        
        
        stage("TRIVY"){
            steps{
                catchError(buildResult: 'SUCCESS', stageResult: 'UNSTABLE') {
                    sh "trivy image --no-progress --exit-code 1 --severity MEDIUM,HIGH,CRITICAL --format table ${IMAGE_NAME}"
                 }   
            }
        }
    }
}
