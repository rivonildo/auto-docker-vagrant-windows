@echo off
echo ========================================
echo  INSTALADOR AUTOMATICO - CLUSTER DOCKER
echo ========================================
echo.
echo Este script ira instalar tudo automaticamente.
echo Aguarde enquanto o PowerShell e executado...
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/rivonildo/auto-docker-vagrant-windows/main/install.ps1 | iex"

pause