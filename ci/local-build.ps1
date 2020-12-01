#!/usr/bin/env pwsh

./ci/calculate-buildInfo.ps1 -isLocalBuild

Write-Host "ProductVersion: $env:BCT_PRODUCT_VERSION"
Write-Host "Branch: $env:BCT_BRANCH"
Write-Host "Release product: $env:BCT_IS_RELEASE_VERSION"

# Docker login to the repo registry
# ./ci/docker-login.ps1 $env:BCT_ARTIFACT_USERNAME $env:BCT_ARTIFACT_APIKEY

# Build and tag the Docker Image
./ci/build.ps1 

# Run Component Tests
./ci/deploy.ps1

./ci/component-tests.ps1

# Push Docker Image to Artifactory
# ./ci/publish.ps1

# Clean Up Artifactory and Docker
./ci/cleanup.ps1
