echo "Digite a URL que está no canal #webhook:"
read WEBHOOK

sed -i 's|inserir_webhook|'$WEBHOOK'|' ./producer/Dockerfile
sed -i 's|inserir_webhook|'$WEBHOOK'|' docker-compose.yml
