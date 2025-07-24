# Stage 1: Build the Go application
FROM golang:1.24-alpine AS builder

# Install necessary build tools (ca-certificates for HTTPS)
RUN apk add --no-cache ca-certificates

# Set the working directory to the project root
WORKDIR /app

# Copy the entire project into the container
COPY . .

# Build the Go application as a static binary
# Specify the path to your main.go file relative to the WORKDIR /app
RUN CGO_ENABLED=0 GOOS=linux go build -a -ldflags="-w -s" -o myapp ./cmd/main.go

# Stage 2: Create a minimal runtime image using scratch
FROM scratch

# Set the working directory
WORKDIR /

# Copy the compiled binary from the builder stage
COPY --from=builder /app/myapp /myapp

# If your application makes HTTPS requests, copy CA certificates
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

# Define the command to run the application
ENTRYPOINT ["/myapp"]
