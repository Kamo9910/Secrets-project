pipeline {
  agent any
  environment {
    AWS_REGION = "us-east-1"
    ECR_REPO = "688352896861.dkr.ecr.us-east-1.amazonaws.com/secret-app"
  }
  stages {
    stage('Checkout') {
      steps {
        git branch: 'main', url: 'https://github.com/Kamo9910/Secrets-project'
      }
    }
    stage('Build Docker Image') {
      steps {
        sh 'docker build -t secret-app:latest .'
      }
    }
    stage('Push to ECR') {
      steps {
        withCredentials([
          string(credentialsId: 'Access_key_ID', variable: 'AWS_ACCESS_KEY_ID'),
          string(credentialsId: 'Secret_access_key', variable: 'AWS_SECRET_ACCESS_KEY')
        ]) {
          sh '''
            aws ecr get-login-password --region $AWS_REGION | \
            docker login --username AWS --password-stdin $ECR_REPO
            docker tag secret-app:latest $ECR_REPO:latest
            docker push $ECR_REPO:latest
          '''
        }
      }
    }
    stage('Deploy with Terraform') {
      steps {
        withCredentials([
          string(credentialsId: 'Access_key_ID', variable: 'AWS_ACCESS_KEY_ID'),
          string(credentialsId: 'Secret_access_key', variable: 'AWS_SECRET_ACCESS_KEY')
        ]) {
          sh '''
            cd terraform
            terraform init
            terraform apply -auto-approve
          '''
        }
      }
    }
  }
}