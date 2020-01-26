pipeline {
    agent any
    stages {
        stage('Compile') {
            steps {
                sh 'mvn clean package -DskipTests=true'
            }
        }
        stage('Unit Tests') {
            steps {
                sh 'mvn -Dmaven.test.failure.ignore=true test'
            }
        }
         stage('Integration Tests') {
            steps {
                sh 'mvn -Dmaven.test.failure.ignore=true failsafe:integration-test'
            }
        }
    }
    post {
        always {
            junit 'target/failsafe-reports/TEST-*.xml'
        }
        /*failure {
            mail to: 'sivasai.v9@gmail.com', subject: 'The Pipeline failed :(', body:'The Pipeline failed :('
        }*/
    }
}
