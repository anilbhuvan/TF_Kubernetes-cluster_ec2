pipeline {
    agent any

    stages {
        stage('aws version') {
            steps {
                sh 'aws --version'
            }
        }
        stage('AWS Credential Binding') {
            steps {
                withCredentials([[
                $class: 'AmazonWebServicesCredentialsBinding', 
                accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY',
                credentialsId: "${aws-sandbox}"]]) 
            }
        }
    }
}
