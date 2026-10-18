docker-compose stop && docker-compose rm -f && docker volume prune -f && \
  git checkout producer/Dockerfile docker-compose.yml && git pull
