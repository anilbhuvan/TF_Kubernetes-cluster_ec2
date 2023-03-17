pipeline {
    agent any

    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }

        stage('Install AWS CLI') {
            steps {
                sh 'curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"'
                sh 'unzip -o awscliv2.zip'
                sh 'echo <anil1116> | sudo -S ./aws/install'
            }
        }

        stage('AWS Credential Binding') {
            environment {
                AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')
                AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
            }
            steps {
                sh 'aws s3 ls'
            }
        }
    }
}
