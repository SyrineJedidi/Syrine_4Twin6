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

    post {
        success {
            echo "Build succeeded"
        }
        failure {
            echo "Build failed"
        }
    }
}
