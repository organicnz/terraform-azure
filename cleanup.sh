#!/bin/bash

# Remove Terraform state files
rm -f terraform.tfstate 
rm -f terraform.tfstate.backup
rm -f .terraform.lock.hcl

# Delete the .terraform directory
rm -rf .terraform

# Remove generated plan files
rm -f terraform.plan

# Delete backup files
rm -f *.backup
