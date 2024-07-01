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
  }
   post {
        always {
            junit '**/test-results.xml' // Adjust the path to your PHPUnit results file if necessary
        }
    }
}
