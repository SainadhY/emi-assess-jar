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
            
        /*stage('Build Docker Image') {
            /*when {
                branch 'master'
            }
            steps {
                echo '=== Building Image ==='
                script {
                    app = docker.build registry + ":$BUILD_NUMBER"
                }
            }
        }
        stage('Push Docker Image') {
            when {
                branch 'master'
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
                bat "docker rmi $registry:$BUILD_NUMBER"
            }
        }
    }}*/
