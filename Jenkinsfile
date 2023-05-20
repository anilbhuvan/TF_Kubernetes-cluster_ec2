pipeline {
    agent any

    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }

        stage('Install AWS CLI and Terraform') {
            parallel {
                stage('Install AWS CLI') {
                    when {
                        expression { !fileExists("/usr/local/bin/aws") }
                    }
                    steps {
                        sh 'curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"'
                        sh 'sudo apt-get install unzip'
                        sh 'unzip -o awscliv2.zip'
                        sh 'sudo ./aws/install -i /usr/local/aws-cli -b /usr/local/bin'
                    }
                }
                stage('Install Terraform') {
                    steps {
                        script {
                            def terraform_installed = sh(script: "terraform version", returnStatus: true) == 0
                            if (!terraform_installed) {
                                sh 'wget https://releases.hashicorp.com/terraform/1.1.4/terraform_1.1.4_linux_amd64.zip'
                                sh 'unzip terraform_1.1.4_linux_amd64.zip'
                                sh 'sudo mv terraform /usr/local/bin'
                            }
                        }
                    }
                }
            }
        }


        stage('AWS Credential Binding') {
            environment {
                AWS_ACCESS_KEY_ID = credentials('79913a64-3684-4a21-9360-3e58f20a774f')
                AWS_SECRET_ACCESS_KEY = credentials('79913a64-3684-4a21-9360-3e58f20a774f')
            }
            steps {
                sh 'aws configure set region us-east-1'
                sh 'aws configure set output yaml'
            }  
        }


        stage('Configure Terraform') {
            steps {
                sh 'terraform init'
                // sh 'terraform init -backend-config="bucket=myk8stfstatefile" -backend-config="key=terraform.tfstate"'
                sh 'terraform validate'
            }
        }


        stage('Apply terraform infrastructure') {
        environment {
            AWS_ACCESS_KEY_ID = credentials('79913a64-3684-4a21-9360-3e58f20a774f')
            AWS_SECRET_ACCESS_KEY = credentials('79913a64-3684-4a21-9360-3e58f20a774f')
        }
        steps {
            script {
            def exitCode = sh(script: 'terraform plan -detailed-exitcode', returnStatus: true)
            if (exitCode == 2) {
                // sh 'terraform apply --auto-approve'
            }
            }
        }
        }

        stage('Commit to Git') {
            steps {
                script {
                    // Configure Git
                    sh 'git config --global user.email "anilbhuvan1116@gmail.com"'
                    sh 'git config --global user.name "anilbhuvan"'

                    // Set up SSH agent and add private key
                    sshagent(['cb8fabc9-cfcc-4cd4-9724-ef21e5b6b6ca']) {
                        // Add all files
                        sh 'git add .'

                        // Commit the changes
                        sh 'git commit -m "Committing changes from Jenkins pipeline"'

                        // Push the changes
                        sh 'sh git push origin main --force'
                    }
                }
            }
        }

    }
}
