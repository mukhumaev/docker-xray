# Xray for Docker

[Xray](https://github.com/XTLS/Xray-core) in a Docker container.

## Quickstart

To get started, you need a `config.json` configuration file. If you're unsure how to create one, click [here](https://github.com/XTLS/Xray-examples) for examples.

### Running the Container

Follow these steps to run the Xray container:

```bash
# Define the port ranges for inbound or outbound connections by specifying the values from the config.json file.
PORT_RANGES="10808-10809"

# Create a temporary directory:
TMP_DIR=$(mktemp -d)

# Clone the Xray Docker repository:
git clone https://github.com/mukhumaev/docker-xray ${TMP_DIR}

# Build the Docker image:
docker build -t xray "${TMP_DIR}" -f "${TMP_DIR}/Dockerfile"

# Remove any existing container named xray:
docker rm -f xray

# Prepare and place your Xray configuration file in ${HOME}/.xray

# Run the Docker container with the specified configurations:
docker run -d \
    --restart=always \
    --name xray \
    -h xray \
    -p 127.0.0.1:${PORT_RANGES}:${PORT_RANGES} \
    -v ${HOME}/.xray:/etc/xray/:ro \
    xray

```

## Building for Multiple Architectures

To build the Docker image for multiple architectures, use the following command:

```bash

docker buildx build -t xray --platform linux/arm/v7,linux/arm64,linux/amd64 .

```
