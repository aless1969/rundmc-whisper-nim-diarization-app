#!/bin/bash
# Build and push Docker image for rundmc-whisper-nim-diarization-app

set -e

# Configuration
IMAGE_NAME="${IMAGE_NAME:-aless1969/rundmc-whisper-nim-diarization-app}"
IMAGE_TAG="${IMAGE_TAG:-1.0.0}"

echo "🔨 Building rundmc-whisper-nim-diarization-app image..."
echo "   Image: ${IMAGE_NAME}:${IMAGE_TAG}"

# Build the image
docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .

# Also tag as latest
docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:latest

echo ""
echo "✅ Build complete!"
echo ""
echo "To push to registry:"
echo "   docker push ${IMAGE_NAME}:${IMAGE_TAG}"
echo "   docker push ${IMAGE_NAME}:latest"
echo ""
echo "To run locally:"
echo "   docker run -p 7860:7860 ${IMAGE_NAME}:${IMAGE_TAG}"