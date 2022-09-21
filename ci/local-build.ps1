#!/usr/bin/env pwsh

# Build and Tag Docker Image
./ci/build.ps1 

# Publish Docker Image
./ci/publish.ps1

