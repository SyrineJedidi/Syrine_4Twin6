pipeline {
  agent any

  tools {
    // noms des outils tels qu'ils doivent être configurés dans Manage Jenkins -> Global Tool Configuration
    maven "Maven3"
    jdk "JDK17"
  }

  environment {
    // nom de l'image (doit commencer par ton username Docker Hub)
    IMAGE_NAME = "ghaliaelouaer/student"
    // credential id pour Docker Hub (doit exister dans Jenkins)
    DOCKERHUB_CREDENTIALS = "dockerhub"
    // credential id GitHub (doit exister dans Jenkins)
    GITHUB_CREDENTIALS = "github-credentials-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"
  }

  stages {
    stage('Checkout') {
      steps {
        // on clone directement le repo de Ghalia (utilise le credential PAT configuré dans Jenkins)
        git branch: 'main',
            url: 'https://github.com/ghaliaelouaer24/ELOUAER_GHALIA_INFINI2.git',
            credentialsId: env.GITHUB_CREDENTIALS
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

    stage('Docker: Build Image') {
      steps {
        script {
          // utilise le wrapper docker.build fourni par le plugin Pipeline: Docker
          dockerImage = docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
        }
      }
    }

    stage('Docker: Push to Docker Hub') {
      steps {
        script {
          // push de façon sécurisée avec les credentials Jenkins
          docker.withRegistry('https://registry.hub.docker.com', env.DOCKERHUB_CREDENTIALS) {
            dockerImage.push("${IMAGE_TAG}")
           
          }
        }
      }
    }

    stage('Cleanup') {
      steps {
        // nettoyage d'images locales pour libérer de l'espace
        sh "docker image rm ${IMAGE_NAME}:${IMAGE_TAG} || true"
      }
    }
  } // end stages

  post {
    success {
      echo "Build succeeded — image pushed: ${IMAGE_NAME}:${IMAGE_TAG}"
    }
    failure {
      echo "Build failed"
    }
  }
}
