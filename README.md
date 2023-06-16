# Nomad Demo

## [Server configuration](https://developer.hashicorp.com/nomad/docs/configuration)

## Server Setup

```bash
docker run -it --rm \
--privileged \
--network host \
-e NOMAD_DISABLE_PERM_MGMT=true \
-e NOMAD_LOCAL_CONFIG='
			datacenter = "dc1"
			region = "rg"

			data_dir = "/nomad/data/"

			server {
				enabled          = true
				bootstrap_expect = 1
			}

      advertise {
        http = "10.20.6.144:4646"
        rpc  = "10.20.6.144:4647"
        serf = "10.20.6.144:4648"
      }

			bind_addr = "0.0.0.0"
' \
-v "/var/run/docker.sock:/var/run/docker.sock:rw" \
multani/nomad agent
```

## Client Setup

```bash
docker run -it --rm --privileged --network host -e NOMAD_LOCAL_CONFIG='datacenter = "dc1" region = "rg" data_dir = "/nomad/data/" server {enabled = false} client { enabled = true server_join {retry_join = ["10.20.6.144:4647"]}} bind_addr = "0.0.0.0"' -v "/var/run/docker.sock:/var/run/docker.sock:rw" multani/nomad agent
```

## Showcase the server
```bash
docker compose up

# showcase cluster interaction
nomad server members

# list clients
nomad node status

# register a job
nomad run jobs/hello-world.nomad

```