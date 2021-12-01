docker-compose up -d

echo ""
echo "Aguardando a configuração do NIFI."

while [ "$(docker logs saga_nifi_1 2>&1 | grep "Controller initialization took" | wc -l)" != "1" ]; do
  printf "."
  sleep 1
done
