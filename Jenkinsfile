node { 
    stage('AWS Credential Binding') { 
        withCredentials([[
                $class: 'AmazonWebServicesCredentialsBinding', 
                accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY',
                credentialsId: "${aws-sandbox}"]]) 
    }
    stage('terraform init') {
        sh 'terraform init'
    }

    stage('terraform apply') {
        sh 'terraform apply -auto-approve'
    }
}
