#!/bin/bash

# Navigate to the root of the project (one directory up from /scripts/)
cd "$(dirname "$0")/.."

# Generate all necessary folders (Just in case), overall useful for app.
echo "Generating all folders necessary for this project..."
mkdir -p app/{wordpress,nginx} app/wordpress/{themes,plugins} config/{mysql,wordpress} docker/{wordpress,mysql,nginx} prometheus grafana/{datasources,dashboards} docs/ scripts/

# Ensure Docker Compose is available
if ! command -v docker-compose &> /dev/null
then
    echo "Docker Compose could not be found. Please install it first."
    exit 1
fi

# --- Fix permissions for WordPress bind mount ---
echo "Fixing WordPress directory permissions..."

if [ -d "./app/wordpress" ]; then
    echo "./app/wordpress directory found. Adjusting permissions..."

    echo "Changing ownership to user:group '33:33' (fallback for www-data)..."
    chown -R 33:33 ./app/wordpress 2>/dev/null || true  # fallback for systems without www-data

    echo "Changing ownership to user:group 'www-data:www-data'..."
    chown -R www-data:www-data ./app/wordpress 2>/dev/null || true

    echo "Setting directory permissions to 755 for all subdirectories..."
    find ./app/wordpress -type d -exec chmod 755 {} \;

    echo "Setting file permissions to 644 for all files..."
    find ./app/wordpress -type f -exec chmod 644 {} \;

    echo "WordPress directory permissions fixed successfully."
else
    echo "./app/wordpress directory not found. Skipping permission fix."
fi


# --- Generate Nginx config from template using environment variables ---
if [ -f ./app/nginx/default.conf.template ]; then
    echo "Generating Nginx config from template..."
    # Load and export from .env
    set -o allexport
    source .env
    set +o allexport
    # Generate the config.
    envsubst '$NGINX_HOST' < ./app/nginx/default.conf.template > ./app/nginx/default.conf
fi

# Run Docker Compose to bring up all containers
echo "Starting Docker Compose..."
docker-compose up -d

# --- Wait for MySQL container to be ready ---
echo "Waiting for MySQL to be ready..."
max_attempts=30  # Number of retry attempts
attempt=0
until docker exec mysql-server mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "SELECT 1" &> /dev/null; do
    if (( attempt >= max_attempts )); then
        echo "MySQL did not become ready in time. Exiting."
        exit 1
    fi
    attempt=$(( attempt + 1 ))
    echo "Attempt $attempt/$max_attempts: Waiting for MySQL to be available..."
    sleep 3
done

echo "MySQL is ready."

# --- Ensure init-db.sh is in the container (if not already) ---
echo "Copying init-db.sh to MySQL container (if not already present)..."
docker cp ./docker-entrypoint-initdb.d/init-db.sh mysql-server:/docker-entrypoint-initdb.d/

# --- Restart MySQL to trigger initialization ---
echo "Restarting MySQL container to apply init-db.sh..."
docker-compose restart mysql

# Optionally, tail the logs (for debugging purposes)
# docker-compose logs -f

