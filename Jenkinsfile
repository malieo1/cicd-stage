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
                sh 'php bin/phpunit'
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
            // Archive test results and other artifacts
            junit '*/target/test-.xml'
            archiveArtifacts artifacts: '*/target/.jar', allowEmptyArchive: true
        }
}
}
