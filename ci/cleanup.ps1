#!/usr/bin/env pwsh

Push-Location -Path "./dev-tools"    
    docker-compose down -v
Pop-Location
