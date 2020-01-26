pipeline {
    agent any
    stages {
        stage('Compile') {
            steps {
                sh '/usr/local/apache-maven/bin/mvn clean package -DskipTests=true'
            }
        }
        stage('Unit Tests') {
            steps {
                sh 'echo executing unit tests'
                sh '/usr/local/apache-maven/bin/mvn -Dmaven.test.failure.ignore=true test'
            }
        }
         stage('Integration Tests') {
            steps {
                sh 'echo executing integration tests'
                sh '/usr/local/apache-maven/bin/mvn -Dmaven.test.failure.ignore=true failsafe:integration-test'
            }
        }
    }
    /*post {
        always {
            junit 'target/failsafe-reports/TEST-*.xml'
        }*/
        /*failure {
            mail to: 'sivasai.v9@gmail.com', subject: 'The Pipeline failed :(', body:'The Pipeline failed :('
        }*/
    }
}
