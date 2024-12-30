# hash_generator/Dockerfile
FROM alpine:latest

# Install necessary packages
RUN apk add --no-cache apache2-utils bash

# Create directory for hashes
RUN mkdir /hashes

# Copy the hash generator script
COPY hash_generator.sh /hash_generator.sh

# Make the script executable
RUN chmod +x /hash_generator.sh

# Set entrypoint
ENTRYPOINT ["/hash_generator.sh"]
