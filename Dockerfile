# Signaling Server - Public Version
FROM golang:1.18-alpine AS builder

# Install dependencies
RUN apk add --no-cache git protobuf protobuf-dev

# Install protoc-gen-go and protoc-gen-go-grpc
RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.28.1
RUN go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.2.0

WORKDIR /app

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

# Copy source code
COPY . .

# Build from cmd directory
RUN go build -o signaling ./cmd

# Final stage
FROM alpine:latest
RUN apk --no-cache add ca-certificates

WORKDIR /root/
COPY --from=builder /app/signaling .

EXPOSE 8088 8000

CMD ["./signaling"]
