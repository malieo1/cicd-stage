pipeline {
  agent any
      environment {
        APP_NAME = "cicd-stage"
        RELEASE = "1.0.0"
        DOCKER_USER = "dmancloud"
        DOCKER_PASS = 'dockerhub'
        IMAGE_NAME = "${DOCKER_USER}" + "/" + "${APP_NAME}"
        IMAGE_TAG = "${RELEASE}-${BUILD_NUMBER}"
    }
  stages {
    stage('verify version') {
      steps {
        sh 'php --version'
      }
    }
    stage('install dependencies') {
      steps {
        sh 'composer install'
      }
    }
    stage('start server') {
      steps {
        sh 'symfony server:start -d'
      }
    }
stage('Run Tests') {
            steps {
                sh 'vendor/bin/phpunit'
            }
        }
    stage('stop server') {
      steps {
        sh 'symfony server:stop'
      }
    }  
    stage("SonarQube Analysis") {
    steps {
        script {
            withSonarQubeEnv(credentialsId: 'jenkins-sonarqube-token') {
                sh "/home/azureuser/sonar-scanner-6.1.0.4477-linux-x64/bin/sonar-scanner"
            }
        }
    }
 }
  stage("Quality Gate") {
            steps {
                script {
                    waitForQualityGate abortPipeline: false, credentialsId: 'jenkins-sonarqube-token'
                }
            }

        }
        stage("Build & Push Docker Image") {
            steps {
                script {
                    docker.withRegistry('',DOCKER_PASS) {
                        docker_image = docker.build "${IMAGE_NAME}"
                    }

                    docker.withRegistry('',DOCKER_PASS) {
                        docker_image.push("${IMAGE_TAG}")
                        docker_image.push('latest')
                    }
                }
            }

        }
  }
   post {
        always {
            junit 'test-results.xml' 
        }
    }
}
