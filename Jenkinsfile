
pipeline {
    agent any

    options {
        skipDefaultCheckout(true)
    }

    environment {
        SERVER_REGION = 'eu-west-1'
        BUILD_ENV = 'development'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
                echo 'Checked out bootcamp scripts from Git'
            }
        }

        stage('Script Validation') {
            steps {
                echo 'Validating scripts...'
                sh '''
                    set -e
                    test -f health-check.sh
                    bash -n health-check.sh
                    echo "Script syntax OK"
                '''
            }
        }

        stage('Test Scripts') {
            steps {
                echo 'Testing bootcamp scripts...'
                sh '''
                    set -e
                    bash health-check.sh
                '''
            }
        }

        stage('Deploy Scripts') {
            steps {
                echo 'Deploying scripts on EC2'
                sh '''
                    set -e
                    mkdir -p /var/lib/jenkins/bootcamp-labs/scripts
                    cp health-check.sh /var/lib/jenkins/bootcamp-labs/scripts/
                    chmod +x /var/lib/jenkins/bootcamp-labs/scripts/health-check.sh
                    echo "Deployment completed successfully"
                '''
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'health-check.sh'
            echo 'Bootcamp Pipeline completed'
        }
        success {
            echo 'Bootcamp Pipeline succeeded!'
        }
        failure {
            echo 'Bootcamp Pipeline failed!'
        }
    }
}
