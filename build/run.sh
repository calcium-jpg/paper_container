#!/bin/sh

if [ ! -f "./eula.txt" ]; then
  printf "eula=$EULA" > ./eula.txt
fi

if [ ! -f "./server.jar" ]; then
  BUILDS_RESPONSE=$(curl -s -H "User-Agent: $USER_AGENT" https://fill.papermc.io/v3/projects/paper/versions/${MINECRAFT_VERSION}/builds)

  # Check if the API returned an error
  if echo "$BUILDS_RESPONSE" | jq -e '.ok == false' > /dev/null 2>&1; then
    ERROR_MSG=$(echo "$BUILDS_RESPONSE" | jq -r '.message // "Unknown error"')
    echo "Error: $ERROR_MSG"
    exit 1
  fi

  # Try to get a stable build URL for the requested version
  PAPERMC_URL=$(echo "$BUILDS_RESPONSE" | jq -r 'first(.[] | select(.channel == "STABLE") | .downloads."server:default".url) // "null"')
  FOUND_VERSION="$MINECRAFT_VERSION"

  # If no stable build for requested version, find the latest version with a stable build
  if [ "$PAPERMC_URL" == "null" ]; then
    echo "No stable build for version $MINECRAFT_VERSION"
    exit 1
  fi

  curl -o server.jar $PAPERMC_URL
  echo "Download completed (version: $FOUND_VERSION)"
fi

exec java -Xmx$MEMORY -jar ./server.jar --nogui
