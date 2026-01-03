# Auto Docker Cluster Install (Windows)

Script PowerShell que automatiza a instalação completa de um cluster Docker Swarm usando Vagrant e VirtualBox.

## Funcionalidades

- ✅ Detecta e atualiza automaticamente o PowerShell 7 (se necessário)
- ✅ Instala automaticamente:
  - Git
  - VirtualBox  
  - Vagrant
- ✅ Clona automaticamente o repositório do cluster: [docker-projeto2-cluster](https://github.com/rivonildo/docker-projeto2-cluster)
- ✅ Inicia o cluster com `vagrant up`
- ✅ Totalmente idempotente (pode rodar várias vezes sem problemas)

## Como usar (Método Fácil)

1. Abra o **PowerShell como Administrador**
2. Execute **apenas este comando**:

```powershell
irm https://raw.githubusercontent.com/SEU_USUARIO/auto-docker-vagrant-windows/main/install.ps1 | iex