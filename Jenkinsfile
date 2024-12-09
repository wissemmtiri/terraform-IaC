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

        stage('Install Terraform') {
            steps {
                echo "Installing Terraform..."
                sh '''
                # Install Terraform (if not already installed)
                if ! command -v terraform &> /dev/null; then
                  curl -fsSL https://releases.hashicorp.com/terraform/1.10.1/terraform_1.10.1_linux_amd64.zip -o terraform.zip
                  unzip terraform.zip
                  sudo mv terraform /usr/local/bin/
                  terraform --version
                fi
                '''
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

        stage('Terraform Plan') {
            steps {
                echo "Planning Terraform changes..."
                sh 'terraform plan -out plan.tfplan -var="client_id=${ARM_CLIENT_ID}" -var="client_secret=${ARM_CLIENT_SECRET}" -var="tenant_id=${ARM_TENANT_ID}" -var="subscription_id=${ARM_SUBSCRIPTION_ID}"'
            }
        }

        stage('Terraform Apply') {
            steps {
                echo "Applying Terraform changes..."
                sh 'terraform apply plan.tfplan -auto-approve -var="client_id=${ARM_CLIENT_ID}" -var="client_secret=${ARM_CLIENT_SECRET}" -var="tenant_id=${ARM_TENANT_ID}" -var="subscription_id=${ARM_SUBSCRIPTION_ID}"'
            }
        }
    }
}
