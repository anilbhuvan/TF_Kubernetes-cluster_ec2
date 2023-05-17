    stage('Create S3 Bucket') {
      steps {
        script {
          sh 'aws configure'  // Configure AWS CLI with access key and secret key
          script {
            def bucketExists = sh (
              script: 'aws s3api head-bucket --bucket my-terraform-state-bucket1156895 --region <region>',
              returnStatus: true
            )
            if (bucketExists == 0) {
              echo 'S3 bucket already exists'
            } else {
              sh 'aws s3api create-bucket --bucket my-terraform-state-bucket1156895 --region <region>'
            }
          }
        }
      }
    }
