# FROM golang:1.21 as builder

# WORKDIR /app
# COPY . .

# RUN go mod init ext_authz && \
# 	go build -o ext-authz ./cmd/main.go

# FROM gcr.io/distroless/base-debian11

# COPY --from=builder /app/ext-authz /ext-authz

# EXPOSE 9000
# ENTRYPOINT ["/ext-authz"]


# Stage 1: Build the Go application
FROM golang:1.24-alpine AS builder

WORKDIR /app

# Copy go.mod and go.sum to download dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy the rest of the application source code
COPY . .

# Build the Go application, statically linking dependencies
# CGO_ENABLED=0 disables CGO, ensuring a static binary
# GOOS=linux sets the target operating system for the binary
# -a ensures all dependencies are statically linked
# -installsuffix cgo is used with -a when CGO_ENABLED=0 to prevent issues
# -ldflags "-s -w" removes debug information and symbol tables, reducing binary size
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags "-s -w" -o myapp .

# Stage 2: Create the final, minimal image
FROM scratch

WORKDIR /app

# Copy only the compiled binary from the builder stage
COPY --from=builder /app/ext-authz .

# Set the entrypoint to run the compiled application
ENTRYPOINT ["/app/ext-authz"]