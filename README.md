# 🚀 Auto Docker Cluster Install (Windows)

Script PowerShell que **automatiza completamente** a instalação de um cluster Docker Swarm utilizando Vagrant e VirtualBox no Windows.

## ✨ Funcionalidades

- ✅ **Detecta e corrige ambiente automaticamente:** Verifica e atualiza para PowerShell 7 se necessário.
- ✅ **Instala todas as dependências automaticamente:**
  - Git
  - VirtualBox
  - Vagrant
- ✅ **Configura o cluster Docker Swarm:**
  - Clona automaticamente o repositório do cluster: [docker-projeto2-cluster](https://github.com/rivonildo/docker-projeto2-cluster)
  - Executa `vagrant up` para subir as máquinas virtuais (master, node1, node2)
  - Configura o Docker Swarm automaticamente
- ✅ **Totalmente idempotente:** Pode ser executado várias vezes sem causar problemas.
- ✅ **Interface amigável:** Inclui um instalador em lote (`.bat`) para usuários não técnicos.

## 🚦 Como Usar

### Método 1: PowerShell (Recomendado para técnicos)

1.  Abra o **PowerShell como Administrador**.
2.  Execute **apenas este comando**:

```powershell
irm https://raw.githubusercontent.com/rivonildo/auto-docker-vagrant-windows/main/install.ps1 | iex

Método 2: Instalador em Lote (Para qualquer pessoa)
Baixe o arquivo Instalar-Cluster-Docker.bat deste repositório.

Clique com o botão direito no arquivo e selecione "Executar como administrador".

Siga as instruções na tela. O processo é totalmente automático.

📋 Requisitos do Sistema
Windows 10/11 64-bit

Conexão com internet

Permissões de administrador (necessárias para instalar software)

Mínimo 8GB de RAM recomendado (para as VMs do cluster)

🛠️ Estrutura do Projeto

auto-docker-vagrant-windows/
├── install.ps1                    # Script principal de instalação
├── Instalar-Cluster-Docker.bat    # Instalador em lote (wrapper)
├── README.md                      # Esta documentação
└── .gitignore                     # Arquivos ignorados pelo Git

🔧 Detalhes Técnicos
O script principal (install.ps1) realiza as seguintes etapas:

Validação do ambiente: Verifica versão do PowerShell e corrige problemas de encoding UTF-8.

Instalação inteligente: Usa o gerenciador de pacotes winget para instalar Git, VirtualBox e Vagrant apenas se não estiverem presentes. Atualiza automaticamente o PATH da sessão para garantir que os comandos fiquem disponíveis imediatamente.

Clone do projeto: Baixa o projeto docker-projeto2-cluster para C:\docker-projeto2-cluster.

Provisionamento do cluster: Executa vagrant up para criar e configurar as três máquinas virtuais do cluster Swarm.

Verificação final: Exibe o status do cluster e instruções para uso.

❓ Solução de Problemas
"Comando não reconhecido" após instalação
O script atualiza o PATH da sessão automaticamente. Se ainda ocorrer, reinicie o PowerShell como administrador e execute o comando novamente.

Erro de política de execução
Caso encontre erros relacionados à política de execução, execute antes:

powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
O vagrant up está lento
A primeira execução pode demorar alguns minutos pois baixa as imagens das VMs. A velocidade depende da sua conexão com a internet.

📄 Licença
Este projeto está licenciado sob a licença MIT. Veja o arquivo LICENSE para detalhes.

👨‍💻 Autor
Criado por Rivonildo - GitHub

⭐ Se este projeto foi útil para você, considere dar uma estrela no repositório!



---

### 🚀 Passos para Atualizar Localmente e no GitHub

Vamos fazer isso **um passo por vez**. Siga exatamente:

**PASSO 1 — Salve o novo README localmente**
1.  Abra o arquivo `README.md` no Bloco de Notas (ou VS Code).
2.  **Apague TODO** o conteúdo atual.
3.  **Cole TODO** o conteúdo do README atualizado (acima).
4.  **Salve** o arquivo.

**✅ Confirmação:**
Após salvar, responda:
**ok**