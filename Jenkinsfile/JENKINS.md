# Jenkins Freestyle Job (CI/CD)
As it is a simple PHP WebApp I use Freestyle(Very simple to configure using the UI)

Major Steps:-

Source Code: *GitHub repo*
Build Step: Execute Shell

## Stop previous containers
`docker compose down`

# Build & deploy new containers
`docker compose build`
`docker compose up -d`

Each push can trigger automatic rebuild & deployment.

