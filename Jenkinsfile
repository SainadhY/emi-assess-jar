pipeline {
    environment {
        registry = "ysainadh/assessapp"
        registryCredential = 'dockerhub'
        dockerImage = ''
    }
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
            steps {
                echo '=== Pushing Docker Image ==='
                script {
                    GIT_COMMIT_HASH = sh (script: "git log -n 1 --pretty=format:'%H'", returnStdout: true)
                    SHORT_COMMIT = "${GIT_COMMIT_HASH[0..7]}"
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerHubCredentials') {
                        app.push("$SHORT_COMMIT")
                        app.push("latest")
                    }
                }
            }
        }
        stage('Remove local images') {
            steps {
                echo '=== Delete the local docker images ==='
                sh "docker rmi $registry:$BUILD_NUMBER"
            }
        }
    }
}
