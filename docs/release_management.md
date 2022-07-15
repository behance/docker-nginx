# Release Management

Github actions provide the machinery for testing (ci.yaml) and producing tags distributed through Docker Hub (publish.yaml). Testing will confirm that `nginx` is able to serve content in various configurations, but also that it can terminate TLS with self-signed certificates. Once a tested and approved PR is merged, simply cutting a new semantically-versioned tag will generate the following matrix of tagged builds:
- `[major].[minor].[patch](?-variant)`
- `[major].[minor](?-variant)`
- `[major](?-variant)`
Platform support is available for architectures:
- `linux/arm64`
- `linux/amd64`

To add new variant based on a new Dockerfile, add an entry to `matrix.props` within `./github/workflows` YAML files.

## Github Actions: Simulation

docker-nginx uses Github Actions for CI/CD. Simulated workflows can be achieved locally with `act`. All commands must be executes from repository root.

Pre-reqs: tested on Mac
1. [Docker Desktop](https://www.docker.com/products/docker-desktop)
1. [act](https://github.com/nektos/act)

Pull request simulation: executes successfully, but only on ARM devices (ex. Apple M1). ARM emulation through QEMU on X64 machines does not implement the full kernel functionality required by nginx at this time.
- `act pull_request`

Publish simulation: executes, but fails (intentionally) without credentials
- `act`
