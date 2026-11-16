#!/bin/bash

# Portas exigidas pelos servicos do docker-compose.yml (porta:servico)
PORTAS_PROJETO=(
  "8090:nifi (Web UI)"
  "8010:nifi (ListenHTTP)"
  "5001:producer_nifi (producer_pedido)"
  "2181:zookeeper"
  "9092:kafka"
  "8070:kowl (Kafka UI)"
  "8081:mongoexpress (Mongo UI)"
  "27017:mongo (MongoDB)"
)

echo "Verificando portas necessárias ao projeto SAGA..."
CONFLITOS=()

for item in "${PORTAS_PROJETO[@]}"; do
  PORTA="${item%%:*}"
  SERVICO="${item#*:}"

  # Verifica se a porta está em escuta no host ou alocada por algum container
  CONTAINER_OCUPANDO=$(docker ps --filter "publish=$PORTA" --format "{{.Names}} (imagem: {{.Image}})" 2>/dev/null | head -n 1)
  PORTA_EM_USO=$(ss -lnt "( sport = :$PORTA )" 2>/dev/null | tail -n +2)

  if [ -n "$CONTAINER_OCUPANDO" ] || [ -n "$PORTA_EM_USO" ]; then
    if [ -n "$CONTAINER_OCUPANDO" ]; then
      ORIGEM="container Docker -> $CONTAINER_OCUPANDO"
    else
      PROC_INFO=$(sudo lsof -nP -iTCP:"$PORTA" -sTCP:LISTEN -F pc 2>/dev/null | paste -sd ' ' - | sed 's/^p/PID /; s/ c/ - /')
      ORIGEM="processo local -> ${PROC_INFO:-desconhecido}"
    fi
    CONFLITOS+=(" - Porta $PORTA [$SERVICO] em uso por: $ORIGEM")
  fi
done

if [ "${#CONFLITOS[@]}" -gt 0 ]; then
  echo ""
  echo "⚠️  ATENÇÃO: Foram encontrados conflitos nas seguintes portas:"
  for c in "${CONFLITOS[@]}"; do
    echo "$c"
  done
  echo ""
  read -r -p "Deseja continuar mesmo assim? (s/N): " RESPOSTA
  case "$RESPOSTA" in
    [sS]|[sS][iI][mM])
      echo "Continuando a execução..."
      ;;
    *)
      echo "Execução cancelada pelo usuário."
      exit 1
      ;;
  esac
else
  echo "✅ Todas as portas necessárias estão livres."
fi

docker-compose up -d

msglog="Started Application Controller"
#msglog="Controller initialization took"

echo ""
echo "Aguardando a configuração do NIFI."
#while [ "$(docker logs saga_nifi_1 2>&1 | grep "$msglog" | wc -l)" != "1" ]; do
while [ "$(docker logs saga-nifi-1 2>&1 | grep "$msglog" | wc -l)" != "1" ]; do
  printf "."
  sleep 1
done
echo ""
echo "Config OK"
echo ""
IP=$(curl -s checkip.amazonaws.com)
echo ""
echo "URLs do projeto:"
echo ""
echo " - NIFI            : http://$IP:8090/nifi"
echo " - PRODUCER        : http://$IP:5001"
echo " - KAFKA UI        : http://$IP:8070"
echo " - Mongo UI        : http://$IP:8081        ( login = fiap , password = fiap )"
echo ""
