#!/bin/bash

DEFAULT_GOAL="help"

if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root. Please use sudo or log in as root."
    exit 1
fi

# Configuration of the project with the wrapper and compilation (excluding tests).
compile() {
    # docker-compose run --rm -w /app maven mvn clean package -DskipTests
    echo "Compilando el docker-compose.yml"
    docker-compose build
}

# Compile the project into the .jar and run it locally (outside the container).
local() {
    compile
    java -jar target/dummyjson-0.0.1-SNAPSHOT.jar
}

# Build the Docker image.
rebuild() {
    docker-compose build
}

# Configure MySQL on the host server.
configure_mysql() {
    ConfigureMySQLDirectory
}

# Start the application using Docker Compose.
start() {
    docker-compose up
}

# Perform a full build and then start the application.
full() {
    compile
    start
}

# Stop and remove Docker containers.
clean() {
    docker-compose down
}

# Configure the directory for MySQL on the host server and container.
function ConfigureMySQLDirectory {
    local directory="/opt/dummy-shopify/mysql-data"

    if [ ! -d "$directory" ]; then
        mkdir -p "$directory"
        echo "Directory created: $directory"

        chown -R :docker "$directory"
        chmod -R g+rwx "$directory"

        docker-compose exec shopify-database mkdir -p "/var/lib/mysql"
        docker-compose exec shopify-database chown -R mysql:mysql "/var/lib/mysql"

        echo "Permissions granted to $directory for the docker group"
    else
        echo "The directory $directory already exists, no need to create it again."
    fi
}

# Display the help message.
help_message() {
    echo -e "\nUsage: $0 [compile|rebuild|start|full|clean|help]"
    echo -e "\n  compile - Compile the project into the .jar (using Maven inside the container)."
    echo "  local   - Compile the .jar and run it without containers."
    echo "  rebuild - Build the Docker image."
    echo "  start   - Configure MySQL and then start the application using Docker Compose."
    echo "  full    - Perform a full build and then start the application."
    echo "  clean   - Stop and remove Docker containers."
    echo "  help    - Display this help message."
}

# Execute the function based on the provided argument or display help.
if [ "$#" -eq 0 ]; then
    help_message
else
    case "$1" in
        compile) compile ;;
        rebuild) rebuild ;;
        start) start ;;
        full) full ;;
        clean) clean ;;
        ConfigureMySQL) ConfigureMySQLDirectory ;;
        help) help_message ;;
        *) echo "Error: Invalid option. Consult the help with '$0 help'." ;;
    esac
fi
