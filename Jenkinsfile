pipeline {
    agent any

    stages {
        stage('AWS Credential Binding') {
            steps {
                sh "aws --version" 
                }
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
