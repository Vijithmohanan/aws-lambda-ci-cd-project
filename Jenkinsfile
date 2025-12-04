pipeline {
    agent any 

    stages {
        stage('Checkout Code') {
            steps {
                // COMMENT: This step pulls the latest code from GitHub.
                checkout scm
            }
        }

        stage('Terraform Init and Plan') {
            steps {
                dir('terraform') { 
                    // Use the full, absolute path found in step 1
                    sh '/opt/homebrew/bin/terraform init' 
                    sh '/opt/homebrew/bin/terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    // Use the full, absolute path here too
                    sh '/opt/homebrew/bin/terraform apply -auto-approve tfplan'
                }
            }
        }

        // You could add an Ansible stage here to configure another resource 
        // after Terraform creates it, but for a Lambda-only deployment, it's often skipped.
        stage('Post-Deployment Test (Optional)') {
            steps {
                // You could use the AWS CLI here to invoke the Lambda and check the output
                echo 'AWS Lambda deployment complete. You can now test the function.'
            }
        }
    }
}
