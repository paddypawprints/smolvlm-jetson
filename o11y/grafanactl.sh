#!/bin/bash

# This script controls a service based on the provided argument.
# It expects one argument: 'start' or 'stop'.
# If 'start' is used, an optional second argument 'interactive' or 'daemon' can be provided.

CONTAINER_NAME="grafana"
MODE="interactive"

# Check the number of arguments
if [ "$#" -ne 1 ] ; then
    echo "Usage: $0 [start|stop]"
    exit 1 # Exit with an error code
else
    ACTION="$1"
fi

# Use a case statement to handle different actions
case "$ACTION" in
    start)
        echo "Starting the service in $MODE mode..."
        if [ "$MODE" = "interactive" ]; then
            # Replace 'startme_interactive' with your actual interactive start command
            docker run -d --rm --name "$CONTAINER_NAME" \
	        -p 3000:3000 \
		--add-host=host.docker.internal:host-gateway\
		-v /home/grafana/grafana-data:/var/lib/grafana \
		-v /home/grafana/grafana-config:/etc/grafana \
		grafana/grafana 
        else
            echo "Invalid mode for start: '$MODE'"
            echo "Usage: $0 start [interactive|daemon]"
            exit 1 # Exit with an error code for invalid mode
        fi
        echo "Service started in $MODE mode."
        ;;
    stop)
        # Ensure no extra arguments are provided for stop
        if [ "$#" -eq 1 ]; then

            echo "Attempting to stop Docker container: $CONTAINER_NAME"

            # Find the container ID by name.
            # `docker ps -aqf "name=^${CONTAINER_NAME}$"`:
            #   - `docker ps`: Lists Docker containers.
            #   - `-a`: Show all containers (running and stopped).
            #   - `-q`: Only display container IDs.
            #   - `-f "name=^${CONTAINER_NAME}$"`: Filter by name, using `^` and `$` for exact match.
            CONTAINER_ID=$(docker ps -aqf "name=^${CONTAINER_NAME}$")

            # Check if a container ID was found
            if [ -z "$CONTAINER_ID" ]; then
              echo "Error: No Docker container found with the name '$CONTAINER_NAME'."
              echo "Please ensure the container name is correct and the container exists."
            else
              echo "Found container ID: $CONTAINER_ID for name: $CONTAINER_NAME"
              echo "Stopping container..."
              # Stop the container using its ID
              # `docker stop $CONTAINER_ID`: Stops the specified container.
              if docker stop "$CONTAINER_ID"; then
                echo "Successfully stopped container: $CONTAINER_NAME ($CONTAINER_ID)"
              else
                echo "Error: Failed to stop container: $CONTAINER_NAME ($CONTAINER_ID)"
                echo "Please check Docker logs for more details."
              fi
            fi
        fi
        ;;
    *)
        echo "Invalid argument: '$ACTION'"
        echo "Usage: $0 [start|stop] [interactive|daemon (optional for start)]"
        exit 1 # Exit with an error code for invalid argument
        ;;
esac

exit 0 # Exit successfully
