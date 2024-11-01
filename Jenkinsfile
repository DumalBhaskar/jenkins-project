pipeline {
    
    agent any
    
    environment {
        
        IMAGE_NAME = "dumalbhaskar/flask-app:${BUILD_NUMBER}"
    }

    stages {
        
        // stage('checkout') {
        //     steps {
                
        //        git branch: 'main', url: 'https://github.com/DumalBhaskar/jenkins-project.git'
        //     }
        // }


        stage ("lint dockerfile") {
            
            steps {
                
                catchError(buildResult: 'SUCCESS', stageResult: 'UNSTABLE') {
                    
                    sh 'docker run --rm -i hadolint/hadolint < Dockerfile > report.txt'
   
                }
                
                
            }
    
        }
        
        stage('Archive Output') {
            steps {
                archiveArtifacts artifacts: 'report.txt', allowEmptyArchive: true
            }
        }

        
        stage('image-build') {
            steps {
                
                sh 'docker build -t ${IMAGE_NAME} .'
            }
        }
        
        
        stage("TRIVY"){
            steps{
                catchError(buildResult: 'SUCCESS', stageResult: 'UNSTABLE') {
                    sh "trivy image --no-progress --exit-code 1 --severity MEDIUM,HIGH,CRITICAL --format table ${IMAGE_NAME}"
                 }   
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
        
        stage('Update-k8s-deployment-file') {
            steps {
                
               withCredentials([string(credentialsId: 'github-token', variable: 'GITHUB_TOKEN')]) {

                cleanWs()
                    sh """
                        git clone https://${GITHUB_TOKEN}@github.com/DumalBhaskar/flask-manifest.git
                        cd flask-manifest
                        sed -i "s|image:.*|image: ${IMAGE_NAME}|g" deployment.yaml
                        git config user.email "dumalbhaskar@gmail.com" ## replace with your github useremail
                        git config user.name "dumalbhaskar"            ## replace with your github usernamename
                        git add deployment.yaml
                        git commit -m "Update deployment image to version ${BUILD_NUMBER}"
                        git push https://${GITHUB_TOKEN}@github.com/DumalBhaskar/flask-manifest.git
                    """
                    cleanWs()

               }
            }
        }
       
    }
}
