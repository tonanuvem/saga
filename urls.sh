IP=$(curl -s checkip.amazonaws.com)
echo ""
echo "URLs do projeto:"
echo ""
echo " - NIFI            : http://$IP:8090/nifi"
echo " - PRODUCER        : http://$IP:5001"
echo " - KAFKA UI        : http://$IP:8070"
echo " - Mongo UI        : http://$IP:8081        ( login = fiap , password = fiap )"
echo ""
