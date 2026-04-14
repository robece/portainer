# portainer

Docker container management UI for CRONOS.

## Overview

Portainer provides a web interface to manage Docker containers, images, volumes, and networks. Runs on port 9000 and connects directly to the Docker socket.

## Requirements

- Docker

## Configuration

No environment variables required. Portainer stores all configuration in its data volume.

## Deploy

### Local development

```bash
./deploy/setup.sh
./deploy/teardown.sh
```

**Windows only — open firewall ports:**
```powershell
.\deploy\firewall-config.ps1
.\deploy\firewall-config.ps1 -Remove
```

### Production

Deployments are managed via Azure DevOps pipeline (`deploy/pipeline.yml`).

## Ports

| Port | Protocol | Description |
|---|---|---|
| 9000 | TCP | Portainer web UI |

## Logs

```bash
docker compose logs -f
```
