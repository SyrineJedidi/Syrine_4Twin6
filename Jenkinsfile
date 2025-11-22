pipeline {
  agent any

  tools {
    maven "Maven3"
    jdk "JDK17"
  }

  environment {
    // ADAPTE ICI ton image Docker Hub si besoin
    DOCKER_IMAGE = "ghaliaelouaer/monapp"
    DOCKERHUB_CREDENTIALS = "dockerhub"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build (Maven)') {
      steps {
        sh "mvn clean package -DskipTests"
      }
    }

    stage('Archive') {
      steps {
        archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
      }
    }

    stage('Build Docker image') {
      steps {
        script {
          env.IMAGE_TAG = "${env.BUILD_NUMBER}-${sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()}"
          sh "docker build -t ${DOCKER_IMAGE}:${IMAGE_TAG} ."
          sh "docker tag ${DOCKER_IMAGE}:${IMAGE_TAG} ${DOCKER_IMAGE}:latest"
        }
      }
    }

    stage('Push Docker image') {
      steps {
        withCredentials([usernamePassword(credentialsId: env.DOCKERHUB_CREDENTIALS, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
          sh 'echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin'
          sh "docker push ${DOCKER_IMAGE}:${IMAGE_TAG}"
          sh "docker push ${DOCKER_IMAGE}:latest"
          sh 'docker logout'
        }
      }
    }
  } // end stages

  post {
    success {
      echo "Build réussi — image poussée : ${DOCKER_IMAGE}:${IMAGE_TAG}"
    }
    failure {
      echo "Build échoué"
    }
  }
}
