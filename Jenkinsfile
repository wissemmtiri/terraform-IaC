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
                withCredentials([string(credentialsId: 'azure-client-id', variable: 'ARM_CLIENT_ID'),
                                 string(credentialsId: 'azure-client-secret', variable: 'ARM_CLIENT_SECRET'),
                                 string(credentialsId: 'azure-tenant-id', variable: 'ARM_TENANT_ID'),
                                 string(credentialsId: 'azure-subscription-id', variable: 'ARM_SUBSCRIPTION_ID')]) {
                    sh '''
                    export ARM_CLIENT_ID=${ARM_CLIENT_ID}
                    export ARM_CLIENT_SECRET=${ARM_CLIENT_SECRET}
                    export ARM_TENANT_ID=${ARM_TENANT_ID}
                    export ARM_SUBSCRIPTION_ID=${ARM_SUBSCRIPTION_ID}
                    '''
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                echo "Planning Terraform changes..."
                sh 'terraform plan -out plan.tfplan'
            }
        }

        stage('Terraform Apply') {
            steps {
                echo "Applying Terraform changes..."
                sh 'terraform apply plan.tfplan -auto-approve'
            }
        }
    }
}
