pipeline {
    environment {
        registry = "ysainadh/assessapp"
        registryCredential = 'docker'
        dockerImage = ''
    }
    agent {label 'ec2-slave'}
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
                 sh 'sudo docker build -t ysainadh/assessapp .'
                }
            }
        }
        stage('Deploy Image') {
            steps{
                echo '=== Pushing Docker Image ==='
                script {
                    GIT_COMMIT_HASH = sh (script: "git log -n 1 --pretty=format:'%H'", returnStdout: true)
                    SHORT_COMMIT = "${GIT_COMMIT_HASH[0..7]}"
                    withDockerRegistry(credentialsId: 'docker', url: 'https://registry.hub.docker.com'){
                        //app.push("$SHORT_COMMIT")
                        //app.push("latest")
                        sh 'sudo docker push ysainadh/assessapp:latest'
                    }
                }
            }
        }
    }
}
