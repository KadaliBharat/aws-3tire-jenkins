pipeline {
    agent any

    parameters {
        choice(name: 'ACTION', choices: ['APPLY', 'DESTROY'], description: 'Choose whether to build or destroy the infrastructure')
    }

    environment {
        // AWS Credentials from Jenkins Credentials Store
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        AWS_DEFAULT_REGION    = 'ap-south-1' // Change to your primary region
        
        // Database Credentials from Jenkins Credentials Store
        TF_VAR_db_username    = credentials('db-username')
        TF_VAR_db_password    = credentials('db-password')

        TF_IN_AUTOMATION      = 'true'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                dir('environments/dev') {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                dir('environments/dev') {
                    sh 'terraform validate'
                }
            }
        }

        stage('Terraform Plan') {
            when { expression { params.ACTION == 'APPLY' } }
            steps {
                dir('environments/dev') {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Approval') {
            steps {
                script {
                    def msg = params.ACTION == 'APPLY' ? 'Review the Terraform Plan. Proceed with apply?' : 'WARNING: Proceed with DESTROY?'
                    def userInput = input(id: 'confirm', message: msg, parameters: [ [$class: 'BooleanParameterDefinition', defaultValue: false, description: 'Confirm action', name: 'confirm'] ])
                    if (!userInput) {
                        error "Pipeline aborted by user."
                    }
                }
            }
        }

        stage('Terraform Apply') {
            when { expression { params.ACTION == 'APPLY' } }
            steps {
                dir('environments/dev') {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }

        stage('Terraform Destroy') {
            when { expression { params.ACTION == 'DESTROY' } }
            steps {
                dir('environments/dev') {
                    sh 'terraform destroy -auto-approve'
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
