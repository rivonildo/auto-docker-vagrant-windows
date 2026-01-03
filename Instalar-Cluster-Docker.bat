@echo off
echo ========================================
echo  INSTALADOR AUTOMATICO - CLUSTER DOCKER
echo ========================================
echo.
echo Este script ira instalar tudo automaticamente.
echo Aguarde enquanto o PowerShell e executado...
echo.
echo [ETAPA 1] Configurando ambiente e baixando instalador...
powershell -NoProfile -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; irm https://raw.githubusercontent.com/rivonildo/auto-docker-vagrant-windows/main/install.ps1 -OutFile install_local.ps1"
echo.
echo [ETAPA 2] Executando instalador principal...
powershell -NoProfile -File .\install_local.ps1 -Verbose
echo.
echo [ETAPA 3] Limpeza final...
if exist install_local.ps1 del install_local.ps1
echo.
echo Concluido!
pause