# Start with a base image
FROM golang:1.22.5 as base

# Set the working directory inside the container
WORKDIR /app

COPY go.mod ./

# Download all the dependencies

RUN go mod download 

# Copy the source code to the working directory
COPY . .
# Build the application
RUN go build -o main .

# Reduce the image size using multi-stage builds
FROM gcr.io/distroless/base

# Copy the binary from the previous stage
COPY --from=base /app/main .

# Copy the static files from the previous stage
COPY --from=base /app/static ./static

#Expose port for the application
EXPOSE 8080

#command to run application
CMD [ "./main" ]