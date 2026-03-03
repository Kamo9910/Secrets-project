pipeline {
  agent any
  environment {
    AWS_REGION = "us-east-1"
    ECR_REPO   = "688352896861.dkr.ecr.us-east-1.amazonaws.com/secret-app"
  }
  stages {
    stage('AWS') {
      agent {
        docker{
          image 'amazon/aws-cli'
          args "--entrypoint=''"
        }
      }
      steps {
        sh '''
            aws --version
        '''
      }
    }
    stage('Build') {
      agent {
        docker {
          image 'node:18-alpine'
          reuseNode true
        }
      }
      steps {
        sh '''
        ls -la
        node --version 
        npm --version
        npm ci
        npm start
        ls -la
        '''
      }
    }
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
          usernamePassword(
            credentialsId: 'my-aws-credentials',
            usernameVariable: 'AWS_ACCESS_KEY_ID',
            passwordVariable: 'AWS_SECRET_ACCESS_KEY'
          )
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
          usernamePassword(
            credentialsId: 'my-aws-credentials',
            usernameVariable: 'AWS_ACCESS_KEY_ID',
            passwordVariable: 'AWS_SECRET_ACCESS_KEY'
          )
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