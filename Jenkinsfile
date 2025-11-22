pipeline {
    agent any

    tools {
        maven "Maven3"   // nom configuré dans Jenkins
        jdk "JDK17"           // nom configuré dans Jenkins
    }
       stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/ghaliaelouaer24/ELOUAER_GHALIA_INFINI2.git',
                    credentialsId: 'github-credentials-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	'
            }
        }

        stage('Build') {
            steps {
                sh "mvn clean package -DskipTests"
            }
        }

        stage('Archive') {
            steps {
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
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
    withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
      sh 'echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin'
      sh "docker push ${DOCKER_IMAGE}:${IMAGE_TAG}"
      sh "docker push ${DOCKER_IMAGE}:latest"
      sh 'docker logout'
    }
  }
}
    post {
        success {
            echo "Build succeeded"
        }
        failure {
            echo "Build failed"
        }
    }
}
