#!/usr/bin/env pwsh

$dockerRepo=$env:BCT_DOCKER_REPO_NAME 
$dockerImage=$env:BCT_DOCKER_IMAGE
$version = $env:BCT_PRODUCT_VERSION 
$isReleaseVersion = $([System.Convert]::ToBoolean($env:BCT_IS_RELEASE_VERSION))
$isPublishing = $([System.Convert]::ToBoolean($env:BCT_IS_PUBLISHING))
$apikey = $env:BCT_ARTIFACT_APIKEY

if ($isPublishing) {
	# Adding remove the out folder step to resolve an error when consecutively publishing images
	docker push "${dockerRepo}/${dockerImage}:$version"
	if ($isReleaseVersion)
	{
		docker push "$dockerRepo/${dockerImage}:latest"
	}

	Push-Location ./
		if(Test-Path "BOM.xml") {
			Write-Host "Uploading BOM"
			./ci/upload-artifact.ps1 -artifactPath ./BOM.xml -artifactName bct-flyway-base/${dockerImage}-BOM-${version}.xml -artifactRepository bom-storage
		}
	Pop-Location
}

# If Release Version - tag the branch
if ($isReleaseVersion) {
	git tag -a $version $env:BCT_GIT_SHA -m "Release $version"
	git push origin $version
}
