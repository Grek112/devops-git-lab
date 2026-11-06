
pipeline {
    agent any

    options {
        skipDefaultCheckout(true)
    }

    parameters {
        booleanParam(
            name: 'RUN_HEALTH_CHECK',
            defaultValue: true,
            description: 'Run health check tests'
        )
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
                echo "Branch: ${env.BRANCH_NAME}"
            }
        }

        stage('Validate Scripts') {
            steps {
                sh 'bash -n health-check.sh'
            }
        }

        stage('Parallel Tests') {
            when {
                expression { params.RUN_HEALTH_CHECK }
            }
            parallel {
                stage('Syntax Tests') {
                    steps {
                        sh 'bash -n health-check.sh'
                    }
                }

                stage('Functionality Tests') {
                    steps {
                        sh 'bash health-check.sh'
                    }
                }
            }
        }

        stage('Deploy to Development') {
            when {
                branch 'ec2-development'
            }
            steps {
                sh '''
                    set -e
                    mkdir -p /var/lib/jenkins/bootcamp-labs/dev
                    cp health-check.sh /var/lib/jenkins/bootcamp-labs/dev/
                    echo "Development deployment completed"
                '''
            }
        }

        stage('Deploy to Staging') {
            when {
                branch 'ec2-staging'
            }
            steps {
                sh '''
                    set -e
                    mkdir -p /var/lib/jenkins/bootcamp-labs/staging
                    cp health-check.sh /var/lib/jenkins/bootcamp-labs/staging/
                    echo "Staging deployment completed"
                '''
            }
        }

        stage('Deploy to Production') {
            when {
                branch 'main'
            }
            steps {
                input message: 'Deploy to Production?', ok: 'Deploy'
                sh '''
                    set -e
                    mkdir -p /var/lib/jenkins/bootcamp-labs/prod
                    cp health-check.sh /var/lib/jenkins/bootcamp-labs/prod/
                    echo "Production deployment completed"
                '''
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'health-check.sh'
        }
        success {
            echo 'Pipeline succeeded!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
