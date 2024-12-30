# hash_generator/Dockerfile
FROM alpine:latest

# Install necessary packages
RUN apk add --no-cache apache2-utils bash

# Create directory for hashes
RUN mkdir /hashes

# Copy the hash generator script
COPY hasher.sh /hasher.sh

# Make the script executable
RUN chmod +x /hasher.sh

# Set entrypoint
ENTRYPOINT ["/hasher.sh"]
