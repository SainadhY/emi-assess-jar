pipeline {
    agent any
    stages {
        stage('Compile') {
            steps {
                bat 'mvn clean package -DskipTests=true'
            }
        }
        stage('Unit Tests') {
            steps {
                bat 'mvn test'
            }
        }
         stage('Integration Tests') {
            steps {
                bat 'mvn failsafe:integration-test'
            }
        }
    }
    post {
        always {
            junit 'target/failsafe-reports/TEST-*.xml'
        }
        failure {
            mail to: 'sivasai.v9@gmail.com', subject: 'The Pipeline failed :(', body:'The Pipeline failed :('
        }
    }
}
