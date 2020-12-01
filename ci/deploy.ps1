#!/usr/bin/env pwsh

Push-Location -Path "./dev-tools"
    docker-compose up -d
Pop-Location
