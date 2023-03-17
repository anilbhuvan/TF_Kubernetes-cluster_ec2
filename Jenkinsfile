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
            sh 'whoami'
            sh 'sudo mkdir /usr/local/aws-cli'
            sh 'curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"'
            sh 'unzip -o awscliv2.zip'
            sh 'sudo ./aws/install -i /usr/local/aws-cli -b /usr/local/bin'
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
