# Jenkins Freestyle Job (CI/CD)
As it is a simple PHP WebApp I use Freestyle(Very simple to configure using the UI)

Major Steps:-

Source Code: *GitHub repo*
Build Step: Execute Shell

# Build & deploy new containers
Build the image then push to mine remote repo, then pull back and build the compose 
``` docker build -t ybtamiru/php-todo-app:latest -f Dockerfile .
docker push ybtamiru/php-todo-app:latest
docker compose pull
docker compose up -d ```

Each push can trigger automatic rebuild & deployment.

