Write-Host "==============================="
Write-Host " AUTO SETUP DOCKER + VAGRANT "
Write-Host "==============================="

# -------- CONFIGURAÇÕES --------
$BasePath = "C:\Projetos"
$ProjectName = "auto-docker-vagrant-windows"
$ProjectPath = Join-Path $BasePath $ProjectName
$RepoURL = "https://github.com/rivonildo/auto-docker-vagrant-windows.git"

# -------- CRIAR PASTA BASE --------
if (!(Test-Path $BasePath)) {
    Write-Host "Criando pasta base em $BasePath..."
    New-Item -ItemType Directory -Path $BasePath | Out-Null
}

# -------- CLONAR PROJETO --------
if (!(Test-Path $ProjectPath)) {
    Write-Host "Clonando repositório em $ProjectPath..."
    Set-Location $BasePath
    git clone $RepoURL
} else {
    Write-Host "Projeto já existe. Pulando clone."
}

Set-Location $ProjectPath

# -------- INSTALAR CHOCOLATEY --------
if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Instalando Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

# -------- INSTALAR GIT --------
if (!(Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Instalando Git..."
    choco install git -y
}

# -------- INSTALAR DOCKER --------
Write-Host "Instalando Docker Desktop..."
choco install docker-desktop -y

# -------- INSTALAR VAGRANT --------
Write-Host "Instalando Vagrant..."
choco install vagrant -y

# -------- FINAL --------
Write-Host ""
Write-Host "==============================="
Write-Host " INSTALAÇÃO FINALIZADA COM SUCESSO "
Write-Host "==============================="
Write-Host "Reinicie o computador antes de usar Docker ou Vagrant."
