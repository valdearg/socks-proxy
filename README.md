# Introduction
Creates a basic SOCKS5 proxy via SSH in a container. Can be connected to externally, e.g. browsers

# Setup
Need to set the known_hosts to contain the correct entries for the host:

Query the SSH server and download the hosts details:
`ssh-keyscan -H kyaru.neko.network >> ~/.ssh/known_hosts`

Then check this looks sensible:
`ssh-keygen -F kyaru.neko.network -f ~/.ssh/known_hosts`

# Config
Basic example of running the container, uses key based authentication to authenticate. 

```
services:
  socks-proxy:
    build: .
    container_name: socks-proxy
    restart: unless-stopped
    environment:
      SSH_HOST: <server_address>
      SOCKS_PORT: "4712"
      SSH_USER: "root"
      SSH_KEY: "<private_key_path>"
      BIND_ADDRESS: "0.0.0.0"
    ports:
      - "4712:4712"
    volumes:
      - ${HOME}/.ssh:/root/.ssh:ro
```