pipeline {
  agent any

  tools {
    jdk 'JDK17'
    maven 'Maven3'
  }

  environment {
    GIT_CREDENTIALS_ID = 'github-credentials-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'
    REPO_SSH_URL = 'git@github.com:ghaliaelouaer24/ELOUAER_GHALIA_INFINI2.git'
    BRANCH = 'main'
  }

  stages {
    stage('Check tools') {
      steps {
        sh 'java -version'
        sh 'mvn -version'
        sh 'whoami'
      }
    }

    stage('Checkout') {
      steps {
        checkout([$class: 'GitSCM',
          branches: [[name: "*/${env.BRANCH}"]],
          userRemoteConfigs: [[
            url: env.REPO_SSH_URL,
            credentialsId: env.GIT_CREDENTIALS_ID
          ]]
        ])
      }
    }

    stage('Build (clean → package)') {
      steps {
        sh 'mvn clean package -DskipTests=true'
      }
    }

    stage('Archive artifact') {
      steps {
        archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
      }
    }
  }

  post {
    success { echo 'BUILD SUCCESS - artifact archived.' }
    failure { echo 'BUILD FAILED - see Console Output.' }
  }
}
