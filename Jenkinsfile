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
                    // Change directory to where your .tf files are located
                    sh 'terraform init'
                    // COMMENT: terraform init prepares the workspace and downloads plugins.
                    sh 'terraform plan -out=tfplan'
                    // COMMENT: terraform plan checks the infrastructure definition and saves the execution plan.
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform apply -auto-approve tfplan'
                    // COMMENT: terraform apply executes the plan, creating/updating the AWS resources (Lambda).
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
