#!/bin/bash

# Sistema de Testes Bolt.diy
echo "🧪 Iniciando testes do sistema Bolt.diy..."
echo ""

# Cores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Contadores
TESTS_PASSED=0
TESTS_FAILED=0

# Função para testar
test_component() {
    local name="$1"
    local command="$2"
    local expected="$3"
    
    echo -n "🔍 Testando $name... "
    
    if eval "$command" > /dev/null 2>&1; then
        echo -e "${GREEN}✅ PASSOU${NC}"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}❌ FALHOU${NC}"
        ((TESTS_FAILED++))
    fi
}

# Testes do Sistema
echo "📋 Executando testes do sistema:"
echo ""

# 1. Verificar Node.js
test_component "Node.js (>=18)" "node --version | grep -E 'v(1[8-9]|[2-9][0-9])'"

# 2. Verificar pnpm
test_component "pnpm" "pnpm --version"

# 3. Verificar dependências
test_component "node_modules" "[ -d node_modules ]"

# 4. Verificar build
test_component "Build artifacts" "[ -d build ]"

# 5. Verificar servidor
test_component "Servidor (porta 5173)" "curl -sf http://localhost:5173 > /dev/null"

# 6. Verificar API Health
test_component "API Health" "curl -sf http://localhost:5173/api/health | grep -q 'healthy'"

# 7. Verificar arquivo de configuração
test_component "Arquivo .env.local" "[ -f .env.local ]"

# 8. Verificar scripts
test_component "Script start.sh" "[ -x start.sh ]"

# 9. Verificar documentação
test_component "Documentação" "[ -f SETUP_GUIDE.md ] && [ -f STATUS_PROJETO.md ]"

# 10. Verificar TypeScript
test_component "TypeScript config" "[ -f tsconfig.json ]"

echo ""
echo "📊 Resultados dos Testes:"
echo -e "✅ Testes passaram: ${GREEN}$TESTS_PASSED${NC}"
echo -e "❌ Testes falharam: ${RED}$TESTS_FAILED${NC}"

# Testes funcionais avançados
echo ""
echo "🚀 Testes Funcionais Avançados:"
echo ""

# Teste de performance do servidor
echo -n "⚡ Testando tempo de resposta... "
RESPONSE_TIME=$(curl -o /dev/null -s -w "%{time_total}" http://localhost:5173)
if (( $(echo "$RESPONSE_TIME < 2.0" | bc -l) )); then
    echo -e "${GREEN}✅ Rápido (${RESPONSE_TIME}s)${NC}"
else
    echo -e "${YELLOW}⚠️ Lento (${RESPONSE_TIME}s)${NC}"
fi

# Teste de memória
echo -n "💾 Verificando uso de memória... "
MEMORY_USAGE=$(ps aux | grep -E "remix|vite" | grep -v grep | awk '{sum += $6} END {print sum/1024}')
if [ ! -z "$MEMORY_USAGE" ]; then
    echo -e "${GREEN}✅ ${MEMORY_USAGE} MB${NC}"
else
    echo -e "${YELLOW}⚠️ Não detectado${NC}"
fi

# Verificar portas
echo -n "🌐 Verificando porta 5173... "
if netstat -tuln 2>/dev/null | grep -q ":5173 "; then
    echo -e "${GREEN}✅ Ativa${NC}"
else
    echo -e "${RED}❌ Inativa${NC}"
fi

echo ""
echo "🔧 Informações do Sistema:"
echo "📍 Localização: $(pwd)"
echo "🐧 Sistema: $(uname -s) $(uname -r)"
echo "💻 Arquitetura: $(uname -m)"
echo "🕒 Data/Hora: $(date)"
echo "👤 Usuário: $(whoami)"

echo ""
if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}🎉 TODOS OS TESTES PASSARAM! Sistema 100% funcional.${NC}"
else
    echo -e "${YELLOW}⚠️ Alguns testes falharam. Verifique a configuração.${NC}"
fi

echo ""
echo "📝 Para mais informações, consulte:"
echo "   📖 SETUP_GUIDE.md"
echo "   📊 STATUS_PROJETO.md"
echo "   🌐 http://localhost:5173"