docker-compose up -d

msglog="Started Application Controller"
#msglog="Controller initialization took"

echo ""
echo "Aguardando a configuração do NIFI."
while [ "$(docker logs saga_nifi_1 2>&1 | grep "$msglog" | wc -l)" != "1" ]; do
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
echo " - NIFI            : $IP:8090/nifi"
echo " - PRODUCER        : $IP:5001"
echo " - KAFKA UI        : $IP:8070"
echo " - Mongo UI        : $IP:8081"
echo ""
