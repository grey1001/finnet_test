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
        stage('Checkout') {
            steps {
                script {
                    // Checkout the repository with the specific branch if needed
                    checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/grey1001/finnet_test.git']]])
                }
            }
        }

       stage('Initialize Workspace') {
            steps {
                script {
                    dir("environments/${params.environment}") {
                        sh 'terraform init -reconfigure'
                        // Check if the workspace exists
                        def workspaceExists = sh(script: "terraform workspace select ${params.environment}", returnStatus: true)

                        // If the workspace doesn't exist, create and select it
                        if (workspaceExists != 0) {
                            sh "terraform workspace new ${params.environment}"
                            sh "terraform workspace select ${params.environment}"
                        }
                    }
                }
            }
        }
        stage('Destroy') {
            steps {
                script {
                    checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/grey1001/finnet_test.git']]])
                    dir("environments/${params.environment}") {
                        sh 'terraform init -reconfigure'
                        sh 'terraform destroy -auto-approve'
                    }
                }
            }
        }
    

        
    //    stage('Plan') {
           
    //         steps {
    //             script {
    //                 sh 'pwd'
    //                 // Move to the specific environment directory
    //                 dir("environments/${params.environment}") {
    //                     // Initialize Terraform, forcing reconfiguration
    //                     sh 'terraform init -reconfigure'
        
    //                     // Create a Terraform plan
    //                     sh 'terraform plan -out tfplan || true'  // Continue even if the plan step fails
        
    //                     // Save the plan in a human-readable format
    //                     sh 'terraform show -no-color tfplan > tfplan.txt || true'  // Continue even if show step fails
        
    //                     // Read the plan content
    //                     plan = readFile 'tfplan.txt'
    //                 }
    //             }
    //         }
    //     }


    //     stage('Approval') {
    //         when {
    //             not {
    //                 equals expected: true, actual: params.autoApprove
    //             }
    //         }

    //         steps {
    //             script {
                    
    //                 input message: 'Do you want to apply the plan?',
    //                       parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
    //             }
    //         }
    //     }

    //     stage('Apply') {
    //         steps {
    //             script {
    //                 dir("environments/${params.environment}") {
    //                     sh 'terraform apply -input=false tfplan'
    //                 }
    //             }
    //         }
    //     }
    // }
// }
