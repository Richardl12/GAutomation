#!/bin/bash
# Pacotes utilizados pela o curso de: ${curso}
apt install ${pacotes}
docker pull ${docker_image}
docker run ${docker_image} -p 8080:8080
