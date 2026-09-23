pipeline {
    agent any

    stages {
        stage('Test Jenkins') {
            steps {
                echo 'Jenkins is working!'
                sh 'docker --version'
                sh 'kubectl version --client'
                sh 'git --version'
            }
        }
    }
}