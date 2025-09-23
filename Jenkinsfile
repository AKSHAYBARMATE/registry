pipeline {
    agent any

    environment {
        CONTAINER_NAME = "serviceregistry"
        IMAGE_NAME = "serviceregistry:latest"
        DOCKERFILE_PATH = "." // adjust if Dockerfile is in a subdir
        HOST_PORT = "8761"
        CONTAINER_PORT = "8761" 
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Docker Version') {
            steps {
                sh 'docker --version'
            }
        }

        stage('Build and Run ServiceRegistry') {
            steps {
                script {
                    // Stop and remove existing container if it's running
                    def isRunning = sh(
                        script: "docker ps -q -f name=${CONTAINER_NAME}",
                        returnStdout: true
                    ).trim()
                    
                    if (isRunning) {
                        echo "🛑 Container ${CONTAINER_NAME} is running. Stopping and removing..."
                        sh "docker rm -f ${CONTAINER_NAME}"
                    }

                    // Remove old image if it exists
                    def imageExists = sh(
                        script: "docker images -q ${IMAGE_NAME}",
                        returnStdout: true
                    ).trim()

                    if (imageExists) {
                        echo "🧹 Removing existing image ${IMAGE_NAME}..."
                        sh "docker rmi -f ${IMAGE_NAME}"
                    }

                    // Build new Docker image
                    echo "🐳 Building Docker image ${IMAGE_NAME}..."
                    sh "docker build -t ${IMAGE_NAME} ${DOCKERFILE_PATH}"

                    // Run container
                    echo "🚀 Starting container ${CONTAINER_NAME}..."
                    sh """
                        docker run -d \
                        --name ${CONTAINER_NAME} \
                        -p ${HOST_PORT}:${CONTAINER_PORT} \
                        ${IMAGE_NAME}
                    """
                }
            }
        }
    }

    post {
        always {
            echo '✅ Pipeline execution completed.'
        }
    }
}
