pipeline {
    agent {
        label 'AGENT-1'
    }
    options {
        timeout(time: 30, unit: 'MINUTES') 
        disableConcurrentBuilds()
    }
    stages {
        stage('init') {
            steps {
                sh '''
                cd 01-vpc
                terraform init -reconfigure
                '''
            }
        }
        stage('Plan') {
            steps {
                sh 'echo From plan'
            }
        }
        stage('Approve') {
            steps {
                sh 'echo From Approve'
            }
        }
    }
    post {  //executes based on whether if it is success or failure
        always { 
            echo 'I will always say Hello again!'
        }
        success { 
            echo 'I will run when pipeline is success'
        }
        failure { 
            echo 'I will run when pipeline is failure'
        }
    }
}
