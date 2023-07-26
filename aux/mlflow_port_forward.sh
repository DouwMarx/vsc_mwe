#!/bin/bash

mlruns_dir=${1:-"/data/leuven/344/vsc34493/projects/biased_anomaly_detection/mlruns"}

# Replace 5000 and 6006 with the appropriate port numbers
local_port=5005
remote_port=6006

# Activate the mlflow_support conda environment on the remote machine and start the MLflow UI
ssh -v hpc "conda activate biased_anomaly_detection && cd ${mlruns_dir} && mlflow ui --port ${remote_port}"

## Set up SSH port forwarding from the remote machine to your local machine
#ssh -v -N -f -L ${local_port}:localhost:${remote_port} hpc

# Activate the mlflow_support conda environment on the remote machine and start the MLflow UI
ssh -fNL ${local_port}:localhost:${remote_port} hpc "conda activate biased_anomaly_detection && cd ${mlruns_dir} && mlflow ui --port ${remote_port}"


echo "SSH port forwarding is set up. Access the MLflow UI at http://localhost:${local_port}."
