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
    stage('test hello endpoint') {
      steps {
        script {
          // Wait for the server to start
          sleep(time: 5, unit: "SECONDS")
          // Test the endpoint
          sh 'curl -f http://localhost:8000/hello/world'
        }
      }
    }
    stage('stop server') {
      steps {
        sh 'symfony server:stop'
      }
    }
  }
}