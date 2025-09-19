#!/bin/bash

# Website to check
URL="https://www.google.com" # Url of the application

# Ask the website for its status
STATUS=$(curl -s -o /dev/null -w "%{http_code}" $URL)

# If the website is working
if [ "$STATUS" -eq 200 ]; then
  echo "The application at $URL is UP (200 OK)"
else
  echo "The application at $URL is DOWN (status $STATUS)"
fi
