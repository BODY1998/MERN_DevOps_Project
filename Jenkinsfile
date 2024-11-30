pipeline {
    agent any
    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
        ECR_REPO_URI = '<your_ecr_repo_uri>'
        KUBE_CONFIG = credentials('kubeconfig')
        AWS_CREDENTIALS = credentials('aws-creds')
    }
    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${env.ECR_REPO_URI}:$BRANCH_NAME-$BUILD_NUMBER")
                }
            }
        }
        stage('Push to ECR') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'aws-creds', passwordVariable: 'AWS_SECRET_ACCESS_KEY', usernameVariable: 'AWS_ACCESS_KEY_ID')]) {
                        sh '''
                            aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $ECR_REPO_URI
                            docker push $ECR_REPO_URI:$BRANCH_NAME-$BUILD_NUMBER
                        '''
                    }
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    withKubeConfig([credentialsId: 'kubeconfig']) {
                        sh '''
                            kubectl set image deployment/my-app my-app-container=$ECR_REPO_URI:$BRANCH_NAME-$BUILD_NUMBER
                        '''
                    }
                }
            }
        }
    }
}
