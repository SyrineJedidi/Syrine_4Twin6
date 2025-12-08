pipeline {
    agent any

    tools {
        maven 'Maven3'  // Nom de l’outil Maven configuré dans Jenkins
        jdk 'JDK17'     // Nom du JDK configuré dans Jenkins
    }

    environment {
        IMAGE_NAME = "ghaliaelouaer/student"  // Ton image Docker
        IMAGE_TAG  = "${env.BUILD_NUMBER}"    // Tag basé sur le numéro de build Jenkins
        DOCKER_CREDENTIALS_ID = 'dockerhub'   // ID exact de tes credentials Jenkins
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
                    docker.withRegistry('https://index.docker.io/v1/', "${DOCKER_CREDENTIALS_ID}") {
                        docker.image("${env.IMAGE_NAME}:${env.IMAGE_TAG}").push()
                    }
                }
            }
        }

        stage('Clean up Docker Images') {
            steps {
                sh "docker rmi ${env.IMAGE_NAME}:${env.IMAGE_TAG} || true"
            }
        }
    }

    post {
        success {
            echo "Build, Docker image creation and push completed successfully!"
        }
        failure {
            echo "Pipeline failed. Check the logs for details."
        }
    }
}
