#!/usr/bin/env pwsh

$dockerRepo="stephenwike"
$dockerImage="flyway-base"
$version="1.0.0"
$isReleaseVersion=$true;

docker push "${dockerRepo}/${dockerImage}:$version"
if ($isReleaseVersion)
{
	docker push "$dockerRepo/${dockerImage}:latest"
}
