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
            sh 'curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"'
            sh 'unzip -o awscliv2.zip'
            sh 'sudo ./aws/install -i /usr/local/aws-cli -b /usr/local/bin'
        }
        }

        stage('AWS Credential Binding') {
            environment {
                AWS_ACCESS_KEY_ID = credentials('728ffcdc-9ba7-4e5e-b44d-e004a276a798')
                AWS_SECRET_ACCESS_KEY = credentials('728ffcdc-9ba7-4e5e-b44d-e004a276a798')
            }
            steps {
                sh 'aws s3 ls'
            }
        }
    }
}
