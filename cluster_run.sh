docker stack deploy -c docker-compose-swarm.yml saga
echo ""
echo "Aguardando a configuração do NIFI."
while [ "$(docker service logs saga_nifi 2>&1 | grep "Controller initialization took" | wc -l)" != "1" ]; do
  printf "."
  sleep 1
done
echo ""
echo "Portas disponíveis no projeto:"
echo ""
echo " - NIFI            : 8090/nifi"
echo " - PRODUCER        : 5001"
echo " - KAFKA UI        : 8070"
echo " - Mongo UI        : 8081"
echo ""
