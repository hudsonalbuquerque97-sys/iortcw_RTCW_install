#!/bin/bash

# ============================================================================
# Instalador Automático - Return to Castle Wolfenstein (iortcw)
# Versão: 1.0
# ============================================================================

set -e  # Para em caso de erro

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # Sem cor

# Função para mostrar barra de progresso
show_progress() {
    local current=$1
    local total=$2
    local message=$3
    local percent=$((current * 100 / total))
    local filled=$((percent / 2))
    local empty=$((50 - filled))
    
    printf "\r${BLUE}[${GREEN}"
    printf "%${filled}s" | tr ' ' '█'
    printf "${NC}%${empty}s${BLUE}] ${percent}%% ${NC}- ${message}"
}

# Função para mostrar mensagens
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

log_error() {
    echo -e "${RED}[✗]${NC} $1"
}

# Banner
clear
echo -e "${GREEN}"
echo "╔════════════════════════════════════════════════════════════╗"
echo "║    Instalador Return to Castle Wolfenstein (iortcw)       ║"
echo "║                  Single Player Edition                     ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Verificar se está rodando como root
if [ "$EUID" -eq 0 ]; then 
    log_error "Não execute este script como root!"
    exit 1
fi

# Variáveis
GAMES_DIR="$HOME/Games"
INSTALL_DIR="$GAMES_DIR/iortcw"
WOLF_DATA_DIR="$HOME/.wolf/main"
DESKTOP_FILE="$HOME/.local/share/applications/rtcw.desktop"
TOTAL_STEPS=8
CURRENT_STEP=0

# ============================================================================
# PASSO 1: Verificar e instalar dependências
# ============================================================================
CURRENT_STEP=1
show_progress $CURRENT_STEP $TOTAL_STEPS "Verificando dependências..."
echo ""

log_info "Verificando dependências necessárias..."

DEPENDENCIES="git build-essential libsdl2-dev libopenal-dev libcurl4-openssl-dev"
MISSING_DEPS=""

for dep in git gcc make libsdl2-dev libopenal-dev libcurl4-openssl-dev; do
    if ! dpkg -l | grep -q "^ii  $dep"; then
        MISSING_DEPS="$MISSING_DEPS $dep"
    fi
done

if [ -n "$MISSING_DEPS" ]; then
    log_warning "Dependências faltando:$MISSING_DEPS"
    log_info "Instalando dependências... (requer sudo)"
    
    sudo apt update
    sudo apt install -y $DEPENDENCIES
    
    log_success "Dependências instaladas com sucesso!"
else
    log_success "Todas as dependências já estão instaladas!"
fi

sleep 1

# ============================================================================
# PASSO 2: Criar diretório Games se não existir
# ============================================================================
CURRENT_STEP=2
show_progress $CURRENT_STEP $TOTAL_STEPS "Criando estrutura de diretórios..."
echo ""

if [ ! -d "$GAMES_DIR" ]; then
    log_info "Criando diretório $GAMES_DIR..."
    mkdir -p "$GAMES_DIR"
    log_success "Diretório Games criado!"
else
    log_success "Diretório Games já existe!"
fi

# ============================================================================
# PASSO 3: Clonar repositório iortcw
# ============================================================================
CURRENT_STEP=3
show_progress $CURRENT_STEP $TOTAL_STEPS "Clonando repositório iortcw..."
echo ""

if [ -d "$INSTALL_DIR" ]; then
    log_warning "Diretório $INSTALL_DIR já existe!"
    read -p "Deseja remover e reinstalar? (s/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        log_info "Removendo instalação anterior..."
        rm -rf "$INSTALL_DIR"
    else
        log_error "Instalação cancelada pelo usuário."
        exit 1
    fi
fi

log_info "Clonando iortcw do GitHub..."
cd "$GAMES_DIR"
git clone --progress https://github.com/iortcw/iortcw.git 2>&1 | while IFS= read -r line; do
    if [[ $line =~ ([0-9]+)% ]]; then
        percent="${BASH_REMATCH[1]}"
        show_progress $percent 100 "Baixando repositório... $percent%"
    fi
done
echo ""
log_success "Repositório clonado com sucesso!"

sleep 1

# ============================================================================
# PASSO 4: Compilar versão Single Player
# ============================================================================
CURRENT_STEP=4
show_progress $CURRENT_STEP $TOTAL_STEPS "Compilando Single Player..."
echo ""

log_info "Iniciando compilação do Single Player..."
log_info "Isso pode levar alguns minutos..."

cd "$INSTALL_DIR/SP"

# Compilar com output verboso
make -j$(nproc) 2>&1 | while IFS= read -r line; do
    echo "$line"
    if [[ $line =~ Linking|Building|Compiling ]]; then
        log_info "$line"
    fi
done

if [ -f "build/release-linux-x86_64/iowolfsp.x86_64" ]; then
    log_success "Compilação concluída com sucesso!"
else
    log_error "Falha na compilação!"
    exit 1
fi

sleep 1

# ============================================================================
# PASSO 5: Criar diretório de dados do jogo
# ============================================================================
CURRENT_STEP=5
show_progress $CURRENT_STEP $TOTAL_STEPS "Criando diretório de dados..."
echo ""

log_info "Criando diretório $WOLF_DATA_DIR..."
mkdir -p "$WOLF_DATA_DIR"
log_success "Diretório de dados criado!"

log_warning "IMPORTANTE: Você precisa copiar os arquivos .pk3 do jogo para:"
log_warning "  → $WOLF_DATA_DIR"
log_warning ""
log_warning "Arquivos necessários:"
log_warning "  - pak0.pk3"
log_warning "  - sp_pak1.pk3"
log_warning "  - sp_pak2.pk3"

sleep 2

# ============================================================================
# PASSO 6: Criar script de execução
# ============================================================================
CURRENT_STEP=6
show_progress $CURRENT_STEP $TOTAL_STEPS "Criando script de execução..."
echo ""

log_info "Criando script run_rtcw.sh..."

cat > "$INSTALL_DIR/run_rtcw.sh" << 'EOFSCRIPT'
#!/bin/bash

# Script de execução - Return to Castle Wolfenstein

RTCW_DIR="$HOME/Games/iortcw/SP/build/release-linux-x86_64"
WOLF_DATA="$HOME/.wolf/main"

# Verificar se os dados do jogo existem
if [ ! -f "$WOLF_DATA/pak0.pk3" ]; then
    zenity --error --text="Arquivos do jogo não encontrados!\n\nCopie os arquivos .pk3 para:\n$WOLF_DATA" 2>/dev/null || \
    echo "ERRO: Arquivos .pk3 não encontrados em $WOLF_DATA"
    exit 1
fi

# Executar o jogo
cd "$RTCW_DIR"
./iowolfsp.x86_64 "$@"
EOFSCRIPT

chmod +x "$INSTALL_DIR/run_rtcw.sh"
log_success "Script de execução criado!"

sleep 1

# ============================================================================
# PASSO 7: Criar atalho no menu de aplicativos
# ============================================================================
CURRENT_STEP=7
show_progress $CURRENT_STEP $TOTAL_STEPS "Criando atalho no menu..."
echo ""

log_info "Criando atalho no menu de aplicativos..."

# Criar diretório de aplicações se não existir
mkdir -p "$HOME/.local/share/applications"

# Verificar se o ícone existe
ICON_PATH="$INSTALL_DIR/SP/misc/wolf512.png"
if [ ! -f "$ICON_PATH" ]; then
    log_warning "Ícone não encontrado, usando ícone genérico"
    ICON_PATH="applications-games"
fi

# Criar arquivo .desktop
cat > "$DESKTOP_FILE" << EOFDESKTOP
[Desktop Entry]
Version=1.0
Type=Application
Name=Return to Castle Wolfenstein
GenericName=RTCW Single Player
Comment=Jogue a campanha de Return to Castle Wolfenstein
Icon=$ICON_PATH
Exec=$INSTALL_DIR/run_rtcw.sh
Terminal=false
Categories=Game;ActionGame;
Keywords=rtcw;wolfenstein;fps;shooter;
StartupNotify=true
EOFDESKTOP

chmod +x "$DESKTOP_FILE"
log_success "Atalho criado em: $DESKTOP_FILE"

# Atualizar cache do menu
if command -v update-desktop-database &> /dev/null; then
    update-desktop-database "$HOME/.local/share/applications" 2>/dev/null
fi

sleep 1

# ============================================================================
# PASSO 8: Finalização
# ============================================================================
CURRENT_STEP=8
show_progress $CURRENT_STEP $TOTAL_STEPS "Finalizando instalação..."
echo ""
echo ""

log_success "═══════════════════════════════════════════════════════════"
log_success "    Instalação concluída com sucesso!"
log_success "═══════════════════════════════════════════════════════════"
echo ""

log_info "Informações importantes:"
echo ""
echo -e "  ${BLUE}Localização:${NC}"
echo -e "    • Jogo instalado em: ${GREEN}$INSTALL_DIR${NC}"
echo -e "    • Dados do jogo em: ${GREEN}$WOLF_DATA_DIR${NC}"
echo ""

echo -e "  ${YELLOW}PRÓXIMO PASSO OBRIGATÓRIO:${NC}"
echo -e "    ${RED}Copie os arquivos .pk3 do jogo para:${NC}"
echo -e "    ${GREEN}$WOLF_DATA_DIR${NC}"
echo ""
echo -e "    Arquivos necessários:"
echo -e "      • pak0.pk3"
echo -e "      • sp_pak1.pk3"
echo -e "      • sp_pak2.pk3"
echo ""

echo -e "  ${BLUE}Como jogar:${NC}"
echo -e "    • Procure por ${GREEN}\"RTCW\"${NC} no menu de aplicativos"
echo -e "    • Ou execute: ${GREEN}$INSTALL_DIR/run_rtcw.sh${NC}"
echo ""

echo -e "  ${BLUE}Exemplo de cópia dos arquivos:${NC}"
echo -e "    ${GREEN}cp /caminho/para/rtcw/main/*.pk3 $WOLF_DATA_DIR/${NC}"
echo ""

log_success "═══════════════════════════════════════════════════════════"
echo ""

# Perguntar se deseja abrir o diretório de dados
read -p "Deseja abrir o diretório de dados agora? (s/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Ss]$ ]]; then
    if command -v xdg-open &> /dev/null; then
        xdg-open "$WOLF_DATA_DIR"
    elif command -v nautilus &> /dev/null; then
        nautilus "$WOLF_DATA_DIR"
    elif command -v nemo &> /dev/null; then
        nemo "$WOLF_DATA_DIR"
    fi
fi

exit 0
