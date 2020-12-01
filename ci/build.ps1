#!/usr/bin/env pwsh

# Assigning Global Variables
$dockerRepo=$env:BCT_DOCKER_REPO_NAME 
$dockerImage=$env:BCT_DOCKER_IMAGE
$version = $env:BCT_PRODUCT_VERSION 

# Adding remove the out folder step to resolve an error when consecutively publishing images
docker build -t "${dockerRepo}/${dockerImage}:$version" -t "${dockerRepo}/${dockerImage}:latest" -f ./src/Dockerfile .
