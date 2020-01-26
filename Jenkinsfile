pipeline {
    environment {
        registry = "ysainadh/assessapp"
        registryCredential = 'dockerhub'
        dockerImage = ''
    }
    agent any
    stages {
        stage('Build Application') { 
            steps {
                echo '=== Building Application ==='
                //bat 'mvn -f pom.xml -B -DskipTests clean install package'
                //bat 'mvn -f pom.xml clean install package'
                bat 'mvn clean package -DskipTests=true'
            }
        }
        stage('Test Application') {
            steps {
                echo '=== Unit Testing Application ==='
                //bat 'mvn test'
                bat 'mvn surefire:test'
            }
            steps {
                echo '=== Integration Testing Application ==='
                bat 'mvn failsafe:integration-test'
            }
        }
        post {
            always {
                junit 'target/failsafe-reports/*.xml'
            }
            failure {
                mail to: 'sivasai.v9@gmail.com', subject: 'The Pipeline failed :(', body:'The Pipeline failed :('
            }
        }
    }
}
