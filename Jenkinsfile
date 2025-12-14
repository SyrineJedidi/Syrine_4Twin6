pipeline {
    agent any

    tools {
        maven "Maven3"
        jdk "JDK17"
    }

    environment {
        IMAGE_NAME = "ghaliaelouaer/student"
        IMAGE_TAG = "${env.BUILD_NUMBER}"
        KUBE_NAMESPACE = "devops"
        DOCKER_CREDENTIALS_ID = "dockerhub"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/ghaliaelouaer24/ELOUAER_GHALIA_INFINI2.git',
                    credentialsId: 'test'
            }
        }

        stage('Build (Maven)') {
            steps {
                sh "mvn clean package -DskipTests"
            }
        }

        stage('Archive Artifacts') {
            steps {
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
        }

        stage('Docker: Build Image') {
            steps {
                script {
                    dockerImage = docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
                }
            }
        }

        stage('Docker: Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', "${DOCKER_CREDENTIALS_ID}") {
                        dockerImage.push()
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    withEnv(["KUBECONFIG=${WORKSPACE}/jenkins-kubeconfig"]) {
                        // PVC et secrets MySQL
                        sh "kubectl apply -f k8s/mysql-pvc.yaml -n ${KUBE_NAMESPACE}"
                        sh "kubectl apply -f k8s/mysql-secret.yaml -n ${KUBE_NAMESPACE}"
                        sh "kubectl apply -f k8s/mysql-deployment.yaml -n ${KUBE_NAMESPACE}"
                        sh "kubectl apply -f k8s/mysql-service.yaml -n ${KUBE_NAMESPACE}"

                        // Déploiement Spring Boot
                        sh "kubectl apply -f k8s/spring-deployment.yaml -n ${KUBE_NAMESPACE}"
                        sh "kubectl apply -f k8s/springboot-service.yaml -n ${KUBE_NAMESPACE}"

                        // Attendre que le déploiement Spring soit prêt
                        sh "kubectl rollout status deployment/spring-deployment -n ${KUBE_NAMESPACE}"
                    }
                }
            }
        }

        stage('Cleanup') {
            steps {
                script {
                    sh "docker rmi ${IMAGE_NAME}:${IMAGE_TAG} || true"
                    sh "docker system prune -f"
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline succeeded — Docker image pushed: ${IMAGE_NAME}:${IMAGE_TAG} and deployed to Kubernetes."
        }
        failure {
            echo "Pipeline failed — check logs for errors."
        }
    }
}
