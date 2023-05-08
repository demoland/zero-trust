# Docker Images

## Build Docker image for Vault-server

**Login:**

`docker login -u danfedick`

**Build:**
`docker build -f ./Dockerfile.vault -t danfedick:vault-server .`

**Push:**
`docker push danfedick:vault-server`

## Build Docker image for App-Server

**Login:**

`docker login -u danfedick`

**Build:**
`docker build -f ./Dockerfile.vault -t danfedick:vault-server .`

**Push:**
`docker push danfedick:vault-server`

---

## Notes

**TODO**: Will need to move this into a Github Action to build and push the images to Docker Hub automatically:

### Consul Installation and Configuration

- [Deployment Guide](https://developer.hashicorp.com/consul/tutorials/production-deploy/deployment-guide)