pipeline {
    agent any

    environment {
        // Azure credentials
        ARM_CLIENT_ID     = credentials('azure-client-id')
        ARM_CLIENT_SECRET = credentials('azure-client-secret')
        ARM_TENANT_ID     = credentials('azure-tenant-id')
        ARM_SUBSCRIPTION_ID = credentials('azure-subscription-id')
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo "Checking out the code..."
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                echo "Initializing Terraform..."
                sh '''
                terraform init
                '''
            }
        }

        stage('Export Terraform Variables') {
            steps {
                echo "Exporting Terraform variables..."
                sh '''
                export ARM_CLIENT_ID=${ARM_CLIENT_ID}
                export ARM_CLIENT_SECRET=${ARM_CLIENT_SECRET}
                export ARM_TENANT_ID=${ARM_TENANT_ID}
                export ARM_SUBSCRIPTION_ID=${ARM_SUBSCRIPTION_ID}
                '''
            }
        }

        stage('Validate and Lint') {
            parallel {
                stage('Terraform Validate') {
                    steps {
                        script {
                            sh '''
                            terraform fmt
                            '''
                        }
                    }
                }
                
                stage('Security Scan') {
                    steps {
                        script {
                            sh '''
                            ./tfsec-linux-amd64 .
                            '''
                        }
                    }
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                echo "Planning Terraform changes..."
                sh 'terraform plan -out plan.tfplan'
            }
        }

        stage('Save State Backup'){
            steps {
                echo "Saving state backup..."
                sh '''
                if [ -f terraform.tfstate ]; then
                    cp terraform.tfstate terraform.tfstate.backup
                else
                    echo "No previous state file found to backup."
                fi
                '''
            }
        }

        stage('Terraform Apply') {
            steps {
                echo "Applying Terraform changes..."
                sh 'terraform apply plan.tfplan'
            }
            post {
                failure {
                    echo "Terraform apply failed. Initiating Rollback to previous state..."
                    script {
                        try {
                            sh '''
                            if [ -f terraform.tfstate.backup ]; then
                                cp terraform.tfstate.backup terraform.tfstate
                                terraform apply -refresh-only -auto-approve
                            else
                                echo "No state backup found. Rollback not possible."
                            fi
                            '''
                        }
                        catch (Exception e) {
                            echo "Rollback failed. error: ${e.getMessage()}"
                        }
                    }
                }
                success {
                    echo "Terraform changes applied successfully."
                }
            }
        }
    }
}
