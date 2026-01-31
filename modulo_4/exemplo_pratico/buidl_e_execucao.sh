sudo docker build -t meu-flask-app .
sudo docker run -d -p 5000:5000 --name flask-app meu-flask-app