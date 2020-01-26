pipeline {
    environment {
        registry = "ysainadh/assessapp"
        registryCredential = 'dockerhub'
        dockerImage = ''
    }
    agent any
    stages {
        stage('Cloning Git') {
            steps {
                git 'https://github.com/SainadhY/emi-assess-jar.git'
            }
        }
        stage('Build Application') { 
            steps {
                echo '=== Building Application ==='
                sh 'mvn -B -DskipTests clean package' 
            }
        }
        stage('Test Application') {
            steps {
                echo '=== Testing Application ==='
                sh 'mvn test'
            }
            post {
                always {
                    junit 'target/failsafe-reports/*.xml'
                }
            }
        }
        stage('Build Docker Image') {
            when {
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
                sh "docker rmi $registry:$BUILD_NUMBER"
            }
        }
    }
}
