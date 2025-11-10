FROM golang:1.18.2-bullseye AS builder

# Install protobuf compiler
RUN apt-get update && apt-get install -y protobuf-compiler && rm -rf /var/lib/apt/lists/*

# Install protoc-gen-go and protoc-gen-go-grpc
RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.28.1
RUN go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.2.0

WORKDIR /source

# Copy protobuf files first
COPY signalling/gRPC/packet/signaling.proto ./signalling/gRPC/packet/

# Generate protobuf code
RUN protoc --go_out=. --go_opt=paths=source_relative \
    --go-grpc_out=. --go-grpc_opt=paths=source_relative \
    signalling/gRPC/packet/signaling.proto

# Copy dependency files
COPY go.mod go.sum ./

# Update go.mod to remove private dependency
RUN sed -i '/thinkremote-rtchub/d' go.mod go.sum

# Download dependencies
RUN go mod download

# Copy all source code
COPY . .

# Build the application
RUN go build -o signaling ./cmd/main.go

# Final stage
FROM debian:bullseye-slim
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY --from=builder /source/signaling .

# WebSocket port
EXPOSE 8088
# gRPC port
EXPOSE 8000

ENV VALIDATION_URL "http://authenticator/token/challenge/session"
ENV SCHEMA         "thinkshare"

ENTRYPOINT [ "./signaling" ]