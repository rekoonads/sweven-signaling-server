# Sweven Games Signaling Server

WebRTC signaling server for Sweven Games cloud gaming platform.

## Overview

Battery included signaling server for WebRTC applications.

### Features
- **Dual Protocol Support**: gRPC and WebSocket
- **Automatic Pairing**: Clients are automatically paired with streaming servers
- **Self-contained**: All dependencies managed during build

## Architecture

- **Protocol Handlers**: Supports both WebSocket and gRPC protocols
- **Tenant Management**: Manages client connections and message routing
- **Pair System**: Automatically pairs clients with streaming servers

## Building

The project uses Protocol Buffers for gRPC definitions. The protobuf code is generated during Docker build:

```bash
docker build -t sweven-signaling-server .
```

## Deployment

### Railway

This project is configured for Railway deployment:

1. Push to GitHub
2. Connect repository to Railway
3. Railway will automatically detect Dockerfile and build

The Dockerfile handles:
- Installing protoc and Go protobuf plugins
- Generating gRPC code from `signalling/gRPC/packet/signaling.proto`
- Removing private dependency on thinkremote-rtchub
- Building the signaling server binary

### Environment Variables

- `PORT`: WebSocket server port (default: 8088)
- `GRPC_PORT`: gRPC port (default: 8000)

## Protocol Buffers

The signaling protocol is defined in `signalling/gRPC/packet/signaling.proto`. The generated Go code is created during build time, not committed to the repository.

### Message Types

- `tSTART`: Initiate connection
- `tSDP`: Session Description Protocol message
- `tICE`: ICE candidate message

## Running Locally

```bash
# Generate protobuf code (requires protoc)
protoc --go_out=. --go_opt=paths=source_relative \
    --go-grpc_out=. --go-grpc_opt=paths=source_relative \
    signalling/gRPC/packet/signaling.proto

# Build
go build -o signaling ./cmd

# Run
./signaling
```

## Dependencies
- [grpc](https://pkg.go.dev/google.golang.org/grpc@v1.47.0) - gRPC server for Go
- [websocket](https://github.com/gorilla/websocket) - WebSocket implementation for Go
- [protobuf](https://pkg.go.dev/google.golang.org/protobuf) - Protocol Buffers for Go

## Licensing
Distributed under GNU General Public License v3

## Original Source
Based on [thinkonmay/signaling-server](https://github.com/thinkonmay/signaling-server) - Modified for Sweven Games deployment