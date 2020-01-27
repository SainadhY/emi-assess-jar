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
                 sh 'sudo docker build -t ysainadh/assessapp .'
                }
            }
        }
        stage('Deploy Image') {
            /*steps{
                script {
                    docker.withRegistry( '', registryCredential ) {
                        dockerImage.push()
                    }
                }*/
                echo '=== Pushing Docker Image ==='
                script {
                    GIT_COMMIT_HASH = sh (script: "git log -n 1 --pretty=format:'%H'", returnStdout: true)
                    SHORT_COMMIT = "${GIT_COMMIT_HASH[0..7]}"
                    withDockerRegistry(credentialsId: 'docker', toolName: 'Docker', url: 'https://registry.hub.docker.com'){
                        //app.push("$SHORT_COMMIT")
                        //app.push("latest")
                        sh 'sudo docker push ysainadh/assessapp:latest'
                    }
                }
            }
        }
        /*stage('Remove local images') {
            steps {
                echo '=== Delete the local docker images ==='
                sh "docker rmi $registry:$BUILD_NUMBER"
            }
        }*/
    }
}
