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
    # Combina o PATH da Máquina e do Usuário na sessão atual do PowerShell
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    Log "PATH da sessao atualizado." "Cyan"
}

Clear-Host
Log "==========================================" "Cyan"
Log " AUTO INSTALL - DOCKER CLUSTER COM VAGRANT " "Green"
Log "==========================================" "Cyan"
Log ""
Log "Iniciando preparacao do ambiente..." "Yellow"

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
# CHECK GIT (COM ATUALIZAÇÃO DE PATH)
# --------------------------
if (Command-Exists "git") {
    Log "Git já instalado. Pulando..." "Green"
} else {
    Log "Git não encontrado. Instalando..." "Yellow"
    winget install --id Git.Git -e --source winget
    Update-SessionPath
    # Verificação pós-instalação
    if (Command-Exists "git") {
        Log "Git instalado e disponível no PATH." "Green"
    } else {
        Log "ATENÇÃO: Git instalado, mas não foi encontrado no PATH. Reinicie o PowerShell." "Yellow"
    }
}

# --------------------------
# CHECK VIRTUALBOX (COM ATUALIZAÇÃO DE PATH)
# --------------------------
$virtualBoxPath = "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"

if (Test-Path $virtualBoxPath) {
    Log "VirtualBox já instalado. Pulando..." "Green"
} else {
    Log "VirtualBox não encontrado. Instalando..." "Yellow"
    winget install --id Oracle.VirtualBox -e --source winget
    # Adiciona o caminho específico do VirtualBox ao PATH da sessão
    $env:Path += ";C:\Program Files\Oracle\VirtualBox"
    Log "Caminho do VirtualBox adicionado ao PATH da sessao." "Cyan"
}

# --------------------------
# CHECK VAGRANT (COM ATUALIZAÇÃO DE PATH)
# --------------------------
if (Command-Exists "vagrant") {
    Log "Vagrant já instalado. Pulando..." "Green"
} else {
    Log "Vagrant não encontrado. Instalando..." "Yellow"
    winget install --id Hashicorp.Vagrant -e --source winget
    Update-SessionPath
    # Verificação pós-instalação
    if (Command-Exists "vagrant") {
        Log "Vagrant instalado e disponível no PATH." "Green"
    } else {
        Log "ATENÇÃO: Vagrant instalado, mas não foi encontrado no PATH. Reinicie o PowerShell." "Yellow"
    }
}

Log "Preparação do ambiente concluída com sucesso!" "Cyan"

# --------------------------
# CLONE DO PROJETO
# --------------------------

$projectRoot = "C:\docker-projeto2-cluster"

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

$vagrantStatus = vagrant status --machine-readable 2>$null | Select-String -Pattern "state," | ForEach-Object {
    ($_ -split ",")[3]
}

if ($vagrantStatus -contains "running") {
    Log "Cluster já está rodando. Pulando..." "Green"
} else {
    Log "Subindo máquinas do cluster (pode levar alguns minutos)..." "Yellow"
    vagrant up

    if ($LASTEXITCODE -eq 0) {
        Log "Cluster iniciado com sucesso!" "Green"
    } else {
        Log "Erro ao iniciar o cluster. Verifique os logs do Vagrant." "Red"
        exit 1
    }
}

# --------------------------
# STATUS FINAL
# --------------------------

Log "Exibindo status final do cluster..." "Cyan"
vagrant status

Log "Para acessar as máquinas, use: vagrant ssh master" "Yellow"
Log "Ou use: vagrant ssh node1" "Yellow"
Log "Para ver os nodes do Docker Swarm: vagrant ssh master -c 'docker node ls'" "Cyan"

# --------------------------
# FINALIZAÇÃO
# --------------------------

Log "==========================================" "Cyan"
Log " INSTALAÇÃO E CONFIGURAÇÃO CONCLUÍDAS! " "Green"
Log "==========================================" "Cyan"
Log ""
Log "Próximos passos:" "Yellow"
Log "1. Acesse o master: vagrant ssh master" "White"
Log "2. Liste os nodes do Swarm: docker node ls" "White"
Log "3. Teste um serviço: docker service create --name web -p 8080:80 nginx" "White"
Log ""
Log "O cluster está pronto para uso." "Green"