# 🐺 Instalador Automático - (iortcw) Return to Castle Wolfenstein

[![Linux](https://img.shields.io/badge/Linux-FCC624?style=flat&logo=linux&logoColor=black)](https://www.linux.org/)
[![Bash](https://img.shields.io/badge/Bash-4EAA25?style=flat&logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash/)
[![License](https://img.shields.io/badge/License-GPL--3.0-blue.svg)](https://opensource.org/licenses/GPL-3.0)

Script automatizado para instalar o **Return to Castle Wolfenstein** (iortcw) no Linux, compilando o motor gráfico open source e configurando tudo para você jogar a campanha single-player.

---

## ⚠️ Aviso Legal
Este script **NÃO distribui** o jogo **Return to Castle Wolfenstein**.
Você precisa possuir uma cópia legal do jogo (Steam, GOG ou CD original).
O script apenas instala as ferramentas e configura o ambiente para jogar no Linux.

## ✅ Por que este script é legal?
- iortcw: GPL (código aberto)
- Não distribui arquivos proprietários
- Requer posse legal do jogo original

---

## 📋 O que este script faz?

O `install_iortcw_rtcw.sh` automatiza todo o processo de instalação:

✅ **Instala dependências** necessárias (git, compiladores, bibliotecas SDL2/OpenAL)  
✅ **Cria a estrutura de pastas** (`~/Games/iortcw`)  
✅ **Clona o repositório** iortcw do GitHub  
✅ **Compila automaticamente** a versão Single Player  
✅ **Cria o diretório de dados** `~/.wolf/main` (oculto)  
✅ **Gera script de execução** `run_rtcw.sh` com verificações de segurança  
✅ **Cria atalho no menu** de aplicativos com ícone do jogo  
✅ **Interface visual** com cores e barra de progresso  

### ⚠️ O que o script NÃO faz

❌ **NÃO instala os arquivos do jogo** (`.pk3`)  
❌ **NÃO baixa conteúdo protegido por direitos autorais**

**Você precisa fornecer os arquivos originais do jogo!**

---

## 🎮 Arquivos Necessários (Game Data)

Após executar o instalador, você **DEVE** copiar manualmente os arquivos `.pk3` do jogo original para:

```
~/.wolf/main/
```

### Arquivos obrigatórios:

- `pak0.pk3` (~315 MB) - Arquivos base do jogo
- `sp_pak1.pk3` (~83 MB) - Campanha single-player parte 1
- `sp_pak2.pk3` (~83 MB) - Campanha single-player parte 2

**Tamanho total:** ~480 MB

---

## 📦 Como Obter os Arquivos do Jogo

### Opção 1: CD/DVD Original do Jogo

Se você possui o jogo original em disco:

1. Insira o CD/DVD no computador
2. Monte o disco (geralmente monta automaticamente)
3. Copie os arquivos `.pk3` da pasta `Main` do CD para `~/.wolf/main/`

```bash
# Exemplo (ajuste o caminho do CD conforme seu sistema)
cp /media/cdrom/Main/*.pk3 ~/.wolf/main/
```

### Opção 2: Versão Digital (Steam, GOG, etc.)

Se comprou o jogo digitalmente:

1. Instale o jogo através da plataforma (Steam/GOG/etc)
2. Localize a pasta de instalação
3. Copie os arquivos `.pk3` da pasta `Main`

**Localização típica no Steam/Proton:**
```bash
~/.steam/steam/steamapps/common/Return to Castle Wolfenstein/Main/
```

### Opção 3: Game Data Package (.deb)

Se você tem um pacote `.deb` com os dados do jogo (como `rtcw-en-data_*.deb`):

#### ⚠️ ATENÇÃO - IMPORTANTE!

**O pacote .deb NÃO instala os arquivos no local correto para o iortcw!**

Quando você instala o `.deb`, os arquivos vão para:
```
/usr/share/games/rtcw/main/  ← Local do sistema
```

Mas o iortcw procura em:
```
~/.wolf/main/  ← Pasta oculta no seu home
```

#### Como proceder com arquivo .deb:

**Método A: Instalar e depois copiar**
```bash
# 1. Instale o pacote
sudo dpkg -i rtcw-en-data_*.deb

# 2. Copie os arquivos para o local correto
cp /usr/share/games/rtcw/main/*.pk3 ~/.wolf/main/
```

**Método B: Extrair sem instalar (Recomendado)**
```bash
# 1. Extraia o conteúdo sem instalar no sistema
dpkg-deb -x rtcw-en-data_*.deb rtcw-temp

# 2. Copie os arquivos extraídos
cp rtcw-temp/usr/share/games/rtcw/main/*.pk3 ~/.wolf/main/

# 3. Remova a pasta temporária
rm -rf rtcw-temp
```

---

## 🚨 IMPORTANTE: Pasta Oculta `.wolf`

### ⚠️ A pasta `.wolf` é OCULTA!

O diretório `~/.wolf/main/` começa com um **ponto (.)**, o que significa que é uma **pasta oculta** no Linux.

### Como visualizar pastas ocultas:

**No gerenciador de arquivos (Nautilus/Nemo):**
- Pressione `Ctrl + H` para mostrar/ocultar arquivos e pastas ocultas
- Ou vá em Menu → Exibir → Mostrar arquivos ocultos

**No terminal:**
```bash
ls -la ~/  # Lista incluindo arquivos ocultos
```

### Navegando até a pasta:

**Via gerenciador de arquivos:**
1. Abra o gerenciador de arquivos
2. Vá para a pasta pessoal (Home)
3. Pressione `Ctrl + H` para mostrar pastas ocultas
4. Procure pela pasta `.wolf`
5. Entre em `.wolf` → `main`
6. Cole os arquivos `.pk3` aqui

**Via terminal:**
```bash
# Navegue até a pasta
cd ~/.wolf/main/

# Liste o conteúdo
ls -lh

# Ou abra no gerenciador de arquivos
xdg-open ~/.wolf/main/
```

---

## 🚀 Como Usar o Instalador

### Pré-requisitos

- **Linux Mint** (ou qualquer distribuição baseada em Debian/Ubuntu)
- **Conexão com a internet**
- **~500 MB de espaço livre** (para compilação)
- **Permissões sudo** (para instalar dependências)

### Passo 1: Baixar o script

```bash
# Clone este repositório ou baixe o script
wget https://github.com/hudsonalbuquerque97-sys/iortcw_RTCW_install/blob/main/install_iortcw_rtcw.sh
# ou
curl -O https://github.com/hudsonalbuquerque97-sys/iortcw_RTCW_install/blob/main/install_iortcw_rtcw.sh
```

### Passo 2: Dar permissão de execução

```bash
chmod +x install_iortcw_rtcw.sh
```

### Passo 3: Executar o instalador

```bash
./install_iortcw_rtcw.sh
```

O script irá:
- Pedir senha (sudo) para instalar dependências
- Clonar e compilar automaticamente
- Criar toda a estrutura necessária
- Exibir instruções sobre copiar os arquivos `.pk3`

### Passo 4: Copiar os arquivos do jogo

**Após a instalação, VOCÊ DEVE copiar os arquivos `.pk3`:**

```bash
# Certifique-se de que a pasta existe
ls ~/.wolf/main/

# Copie os arquivos (ajuste o caminho de origem)
cp /caminho/para/seus/arquivos/*.pk3 ~/.wolf/main/

# Verifique se copiou corretamente
ls -lh ~/.wolf/main/
```

Você deve ver algo como:
```
-rw-r--r-- 1 usuario usuario 315M pak0.pk3
-rw-r--r-- 1 usuario usuario  83M sp_pak1.pk3
-rw-r--r-- 1 usuario usuario  83M sp_pak2.pk3
```

### Passo 5: Jogar!

**Opção A: Via menu de aplicativos**
- Procure por "RTCW" ou "Return to Castle Wolfenstein" no menu
- Clique no ícone

**Opção B: Via terminal**
```bash
~/Games/iortcw/run_rtcw.sh
```

---

## 📁 Estrutura de Diretórios

Após a instalação:

```
~/Games/
└── iortcw/                           # Instalação principal
    ├── SP/                           # Código fonte Single Player
    │   ├── build/
    │   │   └── release-linux-x86_64/
    │   │       └── iowolfsp.x86_64   # Executável do jogo
    │   └── misc/
    │       └── wolf512.png           # Ícone do jogo
    ├── MP/                           # Código fonte Multiplayer
    └── run_rtcw.sh                   # Script de execução ⭐

~/.wolf/                              # Pasta OCULTA de dados
└── main/                             # ⚠️ COPIE OS .pk3 AQUI!
    ├── pak0.pk3                      # ← Você precisa copiar
    ├── sp_pak1.pk3                   # ← Você precisa copiar
    └── sp_pak2.pk3                   # ← Você precisa copiar

~/.local/share/applications/
└── rtcw.desktop                      # Atalho no menu
```

---

## ❓ Solução de Problemas

### "Arquivos do jogo não encontrados"

**Causa:** Os arquivos `.pk3` não foram copiados para `~/.wolf/main/`

**Solução:**
```bash
# Verifique se a pasta existe
ls -la ~/.wolf/main/

# Verifique se os arquivos estão lá
ls -lh ~/.wolf/main/*.pk3

# Se não houver arquivos, copie-os
cp /caminho/correto/*.pk3 ~/.wolf/main/
```

### "Não consigo ver a pasta .wolf"

**Causa:** Pastas que começam com ponto (.) são ocultas

**Solução:**
- No gerenciador de arquivos: pressione `Ctrl + H`
- No terminal: use `ls -la` em vez de `ls`

### "O jogo não inicia"

**Verifique:**
1. Se os 3 arquivos `.pk3` estão em `~/.wolf/main/`
2. Se o executável tem permissão de execução:
   ```bash
   chmod +x ~/Games/iortcw/run_rtcw.sh
   ```
3. Se as dependências foram instaladas:
   ```bash
   dpkg -l | grep libsdl2-dev
   ```

### "Erro de compilação"

**Causa:** Dependências faltando ou versão antiga do GCC

**Solução:**
```bash
sudo apt update
sudo apt install build-essential libsdl2-dev libopenal-dev libcurl4-openssl-dev
```

---

## 🔧 Desinstalação

Para remover completamente:

```bash
# Remover instalação
rm -rf ~/Games/iortcw

# Remover dados do jogo (cuidado: apaga seus saves!)
rm -rf ~/.wolf

# Remover atalho do menu
rm ~/.local/share/applications/rtcw.desktop
```

---

## 📝 Checklist Rápido

Use este checklist após a instalação:

- [ ] Script executado com sucesso
- [ ] Pasta `~/Games/iortcw` criada
- [ ] Pasta `~/.wolf/main` existe (lembre-se: é oculta!)
- [ ] Arquivos `.pk3` copiados para `~/.wolf/main/`
- [ ] Comando `ls ~/.wolf/main/*.pk3` mostra 3 arquivos
- [ ] Atalho "RTCW" aparece no menu de aplicativos
- [ ] Jogo inicia sem erros

---

## 🎯 Resumo para Iniciantes

**TL;DR - Versão simplificada:**

1. Execute: `./install_rtcw.sh`
2. Pressione `Ctrl + H` no gerenciador de arquivos para ver pastas ocultas
3. Copie `pak0.pk3`, `sp_pak1.pk3` e `sp_pak2.pk3` para a pasta `.wolf/main`
4. Procure "RTCW" no menu e jogue!

---

## 📄 Licença

Este script é fornecido como está, sem garantias. O iortcw é licenciado sob GPL-3.0.

**Return to Castle Wolfenstein** é propriedade da id Software / Bethesda. Você deve possuir uma cópia legítima do jogo para usar este instalador.

---

## 🤝 Contribuições

Encontrou algum problema? Tem sugestões? Abra uma issue ou pull request!

---

## ℹ️ Informações Adicionais

- **Motor gráfico:** iortcw (https://github.com/iortcw/iortcw)
- **Versão compilada:** Single Player (SP)
- **Plataforma:** Linux x86_64
- **Testado em:** Linux Mint 21+, Ubuntu 22.04+

---

**Feito com ❤️ para a comunidade Linux Gaming**
