#!/bin/bash
 pid_file="/path/to/mlflow_server.pid"
 if [ -f "$pid_file" ]; then
   pid=$(cat "$pid_file")
   kill "$pid"
   rm "$pid_file"
   echo "MLflow server stopped."
 else
   echo "PID file not found. Server might not be running or already stopped."
 fi


#   ```bash
#   ssh hpc "bash /path/to/stop_mlflow_server.sh"


# This has also been successfull if you run it on the cluster
#   ps aux | grep mlflow | grep -v grep | awk '{print $2}' | xargs kill
