pipeline {
    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
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
                    dir("terraform") {
                        git branch: 'main', url: 'https://github.com/sahil82764/terraform-jenkins.git'
                    }
                }
            }
        }

        stage('Plan') {
            steps {
                sh 'cd terraform/ ; terraform init'
                sh 'cd terraform/ ; terraform plan -out=tfplan'
                sh 'cd terraform/ ; terraform show -no-color tfplan > tfplan.txt'
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
            def plan = readFile 'terraform/tfplan.txt'

            // Use echo to display the plan and wait for user input
            echo "Review the plan:\n${plan}"
            sleep time: 5, unit: 'SECONDS'  // Wait for 5 seconds (adjust as needed)

            // Assume approval if autoApprove is true
            def approval = params.autoApprove ? 'yes' : input(
                message: 'Do you want to apply the plan?',
                parameters: [choice(name: 'Approval', choices: ['yes', 'no'], description: 'Approve or reject the plan')]
            )

            if (approval == 'no') {
                error('Plan rejected. Exiting.')
            }
        }
    }
}


        stage('Apply') {
            steps {
                sh 'cd terraform/ ; terraform apply -input=false tfplan'
            }
        }
    }
}
