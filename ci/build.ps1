#!/usr/bin/env pwsh

# Assigning  Variables
$dockerRepo="stephenwike"
$dockerImage="flyway-base"
$version="1.0.0"

# Build Docker Image
docker build -t "${dockerRepo}/${dockerImage}:${version}" -t "${dockerRepo}/${dockerImage}:latest" -f ./src/Dockerfile .
