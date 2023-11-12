pipeline {
    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
        choice(name: 'environment', choices: ['dev', 'prod', 'stage'], description: 'Select environment for deployment')
    } 
    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    agent any

    stages {
        stage('checkout') {
            steps {
                script {
                    git "https://github.com/yeshwanthlm/Terraform-Jenkins.git"
                    // Optionally switch to a specific branch if needed
                    // sh 'git checkout your_branch_name'
                }
            }
        }

        stage('Plan') {
            steps {
                script {
                    dir("environments/${params.environment}") {
                        sh 'terraform init'
                        sh "terraform workspace select ${params.environment} "
                        sh 'terraform plan -out tfplan'
                        sh 'terraform show -no-color tfplan > tfplan.txt'
                    }
                }
            }
        }

        stage('Approval') {
            when {
                not {
                    equals expected: true, actual: params.autoApprove
                }
            }

            steps {
                script {
                    def plan = readFile "environments/${params.environment}/terraform/tfplan.txt"
                    input message: "Do you want to apply the plan?",
                          parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                }
            }
        }

        stage('Apply') {
            steps {
                script {
                    dir("environments/${params.environment}") {
                        sh 'terraform apply -input=false tfplan'
                    }
                }
            }
        }
    }
}
