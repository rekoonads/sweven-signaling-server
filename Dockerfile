# Signaling Server - Public Version
FROM golang:1.18-alpine AS builder

# Install git for go mod download
RUN apk add --no-cache git

WORKDIR /app

# Copy dependency files
COPY go.mod go.sum ./

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
