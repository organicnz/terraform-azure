#!/bin/bash

# Load Azure credentials from .env file
source .env

# Verify the environment variables were loaded
echo "Environment variables loaded:"
echo "ARM_CLIENT_ID: ${ARM_CLIENT_ID:0:8}..."
echo "ARM_SUBSCRIPTION_ID: ${ARM_SUBSCRIPTION_ID:0:8}..."
echo "ARM_TENANT_ID: ${ARM_TENANT_ID:0:8}..."
echo "ARM_CLIENT_SECRET: [HIDDEN]"

# Add helpful message
echo ""
echo "You can now run Terraform commands without credential parameters"
echo "Terraform will automatically use these environment variables for authentication" 