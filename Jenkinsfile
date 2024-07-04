pipeline {
  agent any
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
  }
   post {
        always {
            junit 'test-results.xml' 
        }
    }
}
