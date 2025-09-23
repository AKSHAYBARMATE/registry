pipeline {
    agent any

    environment {
        CONTAINER_NAME = "schoolregistry"
        IMAGE_NAME = "schoolregistry:latest"
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

        stage('Build and Run schoolregistry') {
            steps {
                script {
                    // Check for any container with the same name (running or stopped)
                    def containerExists = sh(
                        script: "docker ps -a -q -f name=^/${CONTAINER_NAME}\$",
                        returnStdout: true
                    ).trim()

                    if (containerExists) {
                        echo "🛑 Removing existing container ${CONTAINER_NAME}..."
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
