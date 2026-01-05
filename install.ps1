# ==========================================
# AUTO INSTALL - DOCKER CLUSTER COM VAGRANT
# Windows (VirtualBox + Vagrant)
# ==========================================

# --------------------------
# UTF-8 DEFINITIVO
# --------------------------
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()
$OutputEncoding = [System.Text.UTF8Encoding]::new()

# --------------------------
# FUNÇÃO DE LOG
# --------------------------
function Log {
    param (
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host "[AUTO-DOCKER] $Message" -ForegroundColor $Color
}

# --------------------------
# FUNÇÃO: ATUALIZAR PATH DA SESSÃO
# --------------------------
function Update-SessionPath {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" +
                [System.Environment]::GetEnvironmentVariable("Path","User")
    Log "PATH da sessão atualizado." "Cyan"
}

Clear-Host
Log "==========================================" "Cyan"
Log " AUTO INSTALL - DOCKER CLUSTER COM VAGRANT " "Green"
Log "==========================================" "Cyan"
Log ""
Log "Iniciando preparação do ambiente..." "Yellow"

# --------------------------
# CHECK POWERSHELL VERSION
# --------------------------
$psMajor = $PSVersionTable.PSVersion.Major

if ($psMajor -lt 7) {
    Log "PowerShell antigo detectado (v$psMajor)" "Yellow"
    Log "Atualizando para PowerShell 7..." "Yellow"

    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        Log "Winget não encontrado. Atualize o Windows antes de continuar." "Red"
        exit 1
    }

    winget install --id Microsoft.PowerShell -e --source winget
    Log "Reabrindo o script no PowerShell 7..." "Cyan"
    Start-Process pwsh "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    exit
}

Log "PowerShell $($PSVersionTable.PSVersion) OK" "Green"

# --------------------------
# FUNÇÃO: VERIFICAR COMANDO
# --------------------------
function Command-Exists {
    param ([string]$Command)
    return (Get-Command $Command -ErrorAction SilentlyContinue) -ne $null
}

# --------------------------
# CHECK GIT
# --------------------------
if (Command-Exists "git") {
    Log "Git já instalado. Pulando..." "Green"
} else {
    Log "Git não encontrado. Instalando..." "Yellow"
    winget install --id Git.Git -e --source winget
    Update-SessionPath
}

# --------------------------
# CHECK VIRTUALBOX
# --------------------------
$virtualBoxPath = "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"

if (Test-Path $virtualBoxPath) {
    Log "VirtualBox já instalado. Pulando..." "Green"
} else {
    Log "VirtualBox não encontrado. Instalando..." "Yellow"
    winget install --id Oracle.VirtualBox -e --source winget
    $env:Path += ";C:\Program Files\Oracle\VirtualBox"
}

# --------------------------
# CHECK VAGRANT
# --------------------------
if (Command-Exists "vagrant") {
    Log "Vagrant já instalado. Pulando..." "Green"
} else {
    Log "Vagrant não encontrado. Instalando..." "Yellow"
    winget install --id Hashicorp.Vagrant -e --source winget
    Update-SessionPath
}

Log "Preparação do ambiente concluída!" "Cyan"

# ======================================================
# NOVO BLOCO: CRIAR PASTA BASE DO PROJETO (MELHORIA)
# ======================================================

$baseDir = "C:\Projects"
$projectRoot = Join-Path $baseDir "docker-projeto2-cluster"

if (-not (Test-Path $baseDir)) {
    Log "Criando pasta base de projetos em $baseDir" "Yellow"
    New-Item -ItemType Directory -Path $baseDir | Out-Null
} else {
    Log "Pasta base já existe: $baseDir" "Green"
}

# --------------------------
# CLONE DO PROJETO
# --------------------------
if (Test-Path $projectRoot) {
    Log "Projeto já existe em $projectRoot. Pulando clone..." "Green"
} else {
    Log "Clonando repositório do cluster Docker..." "Yellow"
    git clone https://github.com/rivonildo/docker-projeto2-cluster.git $projectRoot
}

# --------------------------
# ACESSAR DIRETÓRIO
# --------------------------
Set-Location $projectRoot
Log "Diretório do projeto pronto para execução." "Cyan"

# --------------------------
# INICIAR CLUSTER COM VAGRANT
# --------------------------
Log "Verificando status do Vagrant..." "Cyan"

$vagrantStatus = vagrant status --machine-readable 2>$null |
    Select-String -Pattern "state," |
    ForEach-Object { ($_ -split ",")[3] }

if ($vagrantStatus -contains "running") {
    Log "Cluster já está rodando. Pulando..." "Green"
} else {
    Log "Subindo máquinas do cluster (pode levar alguns minutos)..." "Yellow"
    vagrant up

    if ($LASTEXITCODE -ne 0) {
        Log "Erro ao iniciar o cluster." "Red"
        exit 1
    }
}

# --------------------------
# STATUS FINAL
# --------------------------
Log "Exibindo status final do cluster..." "Cyan"
vagrant status

Log "==========================================" "Cyan"
Log " INSTALAÇÃO CONCLUÍDA COM SUCESSO! " "Green"
Log "==========================================" "Cyan"
