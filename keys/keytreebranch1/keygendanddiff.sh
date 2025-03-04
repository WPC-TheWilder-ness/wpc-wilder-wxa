#!/bin/bash

# Function to generate key pair
generate_keypair() {
    local name=$1
    
    # Generate private key
    openssl genpkey -algorithm ED25519 \
        -out "${name}.pri.pem"
    
    # Extract public key from private key
    openssl pkey -in "${name}.pri.pem" \
        -pubout -out "${name}.pub.pem"
    
    echo "Generated key pair:"
    echo "Private key: ${name}.pri.pem"
    echo "Public key:  ${name}.pub.pem"
}

# Function to verify public key matches private key
verify_keypair() {
    local pri_key=$1
    local pub_key=$2
    
    # Extract public key from private key
    local temp_pub=$(mktemp)
    openssl pkey -in "$pri_key" -pubout -out "$temp_pub"
    
    # Compare extracted public key with provided public key
    if diff -q "$temp_pub" "$pub_key" >/dev/null; then
        echo "✓ Keys match - public key is derived from private key"
        rm "$temp_pub"
        return 0
    else
        echo "✗ Keys do not match"
        rm "$temp_pub"
        return 1
    fi
}

# Example usage
# Generate a new key pair
# generate_keypair "my_keys"

# Verify a key pair
# verify_keypair "my_keys.pri.pem" "my_keys.pub.pem"
