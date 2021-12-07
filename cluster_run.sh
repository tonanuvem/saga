docker stack deploy -c docker-compose-swarm.yml saga
echo ""
echo "Portas disponíveis no projeto:"
echo ""
echo " - NIFI            : 8090/nifi"
echo " - PRODUCER        : 5001"
echo " - KAFKA UI        : 8070"
echo " - Mongo UI        : 8081"
echo ""
