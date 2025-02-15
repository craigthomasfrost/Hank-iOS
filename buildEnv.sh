#!/bin/sh

# Script to generate Swift struct from .env file

# Usage message function
usage() {
  echo "Require 2 arguments." 1>&2
  echo "Usage: $0 /path/to/.env /output/path" 1>&2
  exit 1
}

# Check for exactly two arguments
if [ $# -ne 2 ]; then
  usage
fi

# Variables for input and output paths
env_file="$1"
output_file="$2/Env.swift"

# Check if the .env file exists
if [ ! -f "$env_file" ]; then
  echo "Error: .env file not found at $env_file" 1>&2
  exit 1
fi

# Initialize Swift struct with a header
code="import Foundation\n\n// This file is auto-generated. Do not edit this file directly.\n\nstruct Env {"

# Read .env file line by line
while IFS='' read -r line || [[ -n "$line" ]]; do
  # Clean up line
  line="${line//[$'\r\n']}"
  # Remove spaces, tabs, etc., to check if line is not empty
  trimline="${line//[$'\t\r\n ']}"

  if [ -n "$trimline" ]; then
    # Split line into KEY and VALUE
    KEY="${line%%=*}"
    VALUE="${line#*=}"
    # Append key-value pair as a static constant within the Env struct
    code="$code\n    static let $KEY = \"$VALUE\""
  fi
done < "$env_file"

# Close the Env struct
code="$code\n}"

# Write the final Swift code to the output path
echo "$code" > "$output_file"

# Exit successfully
exit 0
