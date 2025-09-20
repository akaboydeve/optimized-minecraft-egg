#!/bin/ash
# shellcheck shell=dash


# LeafMC download logic
if [ "${MINECRAFT_VERSION}" = "latest" ]; then
    # Get latest version and build
    LATEST_VERSION=$(curl -s https://api.leafmc.one/v2/projects/leaf | jq -r '.versions[-1]')
    MINECRAFT_VERSION=${LATEST_VERSION}
fi

if [ "${BUILD_NUMBER}" = "latest" ]; then
    LATEST_BUILD=$(curl -s https://api.leafmc.one/v2/projects/leaf/versions/${MINECRAFT_VERSION} | jq -r '.builds[-1].build')
    BUILD_NUMBER=${LATEST_BUILD}
fi

DOWNLOAD_URL="https://api.leafmc.one/v2/projects/leaf/versions/${MINECRAFT_VERSION}/builds/${BUILD_NUMBER}/downloads/leaf-${MINECRAFT_VERSION}-${BUILD_NUMBER}.jar"

cd /mnt/server || exit
printf "Downloading LeafMC version %s build %s\n" "${MINECRAFT_VERSION}" "${BUILD_NUMBER}"

if [ -f "server.jar" ]; then
    mv server.jar server.jar.old
fi

curl -o server.jar "${DOWNLOAD_URL}"

printf "Downloading optimized configuration files\n"

if [ ! -d "config" ]; then
    mkdir config
fi

if [ ! -f "server.properties" ]; then
    curl -o server.properties https://raw.githubusercontent.com/akaboydeve/optimized-minecraft-egg/main/configs/server.properties
fi

if [ ! -f "bukkit.yml" ]; then
    curl -o bukkit.yml https://raw.githubusercontent.com/akaboydeve/optimized-minecraft-egg/main/configs/bukkit.yml
fi

if [ ! -f "spigot.yml" ]; then
    curl -o spigot.yml https://raw.githubusercontent.com/akaboydeve/optimized-minecraft-egg/main/configs/spigot.yml
fi

if [ ! -f "config/paper-global.yml" ]; then
    curl -o config/paper-global.yml https://raw.githubusercontent.com/akaboydeve/optimized-minecraft-egg/main/configs/paper-global.yml
fi

if [ ! -f "config/paper-world-defaults.yml" ]; then
    curl -o config/paper-world-defaults.yml https://raw.githubusercontent.com/akaboydeve/optimized-minecraft-egg/main/configs/paper-world-defaults.yml
fi

if [ ! -f "pufferfish.yml" ]; then
    curl -o pufferfish.yml https://raw.githubusercontent.com/akaboydeve/optimized-minecraft-egg/main/configs/pufferfish.yml
fi

if [ ! -f "config/purpur.yml" ]; then
    curl -o purpur.yml https://raw.githubusercontent.com/akaboydeve/optimized-minecraft-egg/main/configs/purpur.yml
fi
