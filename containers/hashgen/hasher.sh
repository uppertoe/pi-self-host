#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Output file for hashed passwords
OUTPUT_FILE="/hashes/.env.caddy"

# Configuration file with service,username,password triplets
CONFIG_FILE="/users.conf"

# Check if the configuration file exists
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Configuration file $CONFIG_FILE not found!"
    exit 1
fi

echo "Generating bcrypt hashed passwords..."

# Function to generate bcrypt hash using htpasswd
generate_hash() {
    # Usage: generate_hash username password
    htpasswd -nbBC 12 "$1" "$2" | cut -d':' -f2 | sed 's/\$/$$/g'
}

# Initialize the output file
> "$OUTPUT_FILE"

# Read the configuration file line by line
while IFS=, read -r service username password; do
    # Trim whitespace
    service=$(echo "$service" | xargs)
    username=$(echo "$username" | xargs)
    password=$(echo "$password" | xargs)
    
    # Skip empty lines or lines starting with #
    [[ -z "$service" || "$service" =~ ^# ]] && continue
    
    # Generate the hash
    hash=$(generate_hash "$username" "$password")
    
    # Define the variable names
    service_upper="${service^^}"                # Convert service name to uppercase
    service_upper=${service_upper//-/_}         # Replace hyphens with underscores if any
    
    user_var="${service_upper}_USER"
    pass_hash_var="${service_upper}_PASS_HASH"
    
    # Write to the output file
    echo "${user_var}=${username}" >> "$OUTPUT_FILE"
    echo "${pass_hash_var}=${hash}" >> "$OUTPUT_FILE"
done < "$CONFIG_FILE"

echo "Hashed passwords written to $OUTPUT_FILE"
