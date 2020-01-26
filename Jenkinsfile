pipeline {
    environment {
    registry = "ysainadh/assessapp"
    registryCredential = 'dockerhub'
  }
    
    agent any
    stages {
        stage('Compile') {
            steps {
                bat 'mvn clean package -DskipTests=true'
            }
        }
        stage('Unit Tests') {
            steps {
                bat 'mvn -Dmaven.test.failure.ignore=true test'
            }
        }
         stage('Integration Tests') {
            steps {
                bat 'mvn -Dmaven.test.failure.ignore=true failsafe:integration-test'
            }
        }
         stage('Building image') {
            steps{
              script {
                docker.build registry + ":$BUILD_NUMBER"
              }
           }
        }
         stage('Deploy Image') {
              steps{
                script {
                  docker.withRegistry( '', registryCredential ) {
                    dockerImage.push()
                 }
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
