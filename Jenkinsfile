pipeline {
    agent any

    tools {
        maven 'Maven3' // Nom configuré dans Jenkins → Manage Jenkins → Global Tool Configuration
        jdk 'JDK17'    // Nom configuré dans Jenkins
    }

    environment {
        IMAGE_NAME = "ghaliaelouaer/student" // Remplace par ton nom Docker Hub si besoin
        IMAGE_TAG  = "${env.BUILD_NUMBER}"
        DOCKER_CREDENTIALS_ID = 'docker-hub-credentials' // ID des credentials Docker dans Jenkins
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build with Maven') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${env.IMAGE_NAME}:${env.IMAGE_TAG}")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', "${dockerhub}") {
                        docker.image("${env.IMAGE_NAME}:${env.IMAGE_TAG}").push()
                    }
                }
            }
        }

        stage('Clean up Docker Images') {
            steps {
                sh "docker rmi ${env.IMAGE_NAME}:${env.IMAGE_TAG}"
            }
        }
    }

    post {
        success {
            echo "Build, Docker image creation and push completed successfully!"
        }
        failure {
            echo "Something went wrong. Check the logs!"
        }
    }
}
