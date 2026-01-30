# Verificar status do serviço
sudo systemctl status docker

# Configurar Docker para iniciar com o sistema
sudo systemctl enable docker

# Configurar daemon (opcional)
sudo nano /etc/docker/daemon.json

# Exemplo de daemon.json:

#   {
#       "log-driver": "json-file",
#       "log-opts": {
#           "max-size": "10m",
#           "max-file": "3"
#       },
#       "storage-driver": "overlay2"
#   }

