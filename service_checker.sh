#!/bin/bash

SERVICE_NAME=$1

if [ -z "$SERVICE_NAME" ]; then
 echo "Usage: $0 <service_name>"
 exit 1
fi

echo "Checking status of the service: $SERVICE_NAME"

systemctl is-active --quiet "$SERVICE_NAME"

EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
 echo "Status: $SERVICE_NAME is currently active(running)."
else
 echo "Status: $SERVICE_NAME is currently inactive(dead)."
 echo "Attempting to restart $SERVICE_NAME..."

 sudo systemctl restart "$SERVICE_NAME"

 RESTART_CODE=$?

 if [ $RESTART_CODE -eq 0 ]; then
  echo "Successfully sent restart command for $SERVICE_NAME"
  sleep 2
  echo "Rechecking status"
  systemctl is-active --quiet "$SERVICE_NAME"
  if [ $? -eq 0 ]; then
   echo "Status: $SERVICE_NAME is now active!."
  else
   echo "Warning: $SERVICE_NAME still appears inactive after restart attempt."
  fi
 else
  echo "Error: Failed to send restart command for $SERVICE_NAME (Exit Code: $RESTART_CODE)."
 fi
fi

echo "Script Finished."
exit 0
