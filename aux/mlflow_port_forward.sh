#!/bin/bash
#
#mlruns_dir=${1:-"/data/leuven/344/vsc34493/projects/biased_anomaly_detection/mlruns"}
#
## Replace 5000 and 6006 with the appropriate port numbers
#local_port=5005
#remote_port=6006
#
## Activate the mlflow_support conda environment on the remote machine and start the MLflow UI
#ssh -v hpc "conda activate biased_anomaly_detection && cd ${mlruns_dir} && mlflow ui --port ${remote_port}"
#
### Set up SSH port forwarding from the remote machine to your local machine
##ssh -v -N -f -L ${local_port}:localhost:${remote_port} hpc
#
## Activate the mlflow_support conda environment on the remote machine and start the MLflow UI
#ssh -fNL ${local_port}:localhost:${remote_port} hpc "conda activate biased_anomaly_detection && cd ${mlruns_dir} && mlflow ui --port ${remote_port}"
#
#
#echo "SSH port forwarding is set up. Access the MLflow UI at http://localhost:${local_port}."
#
# Other options
#  ssh -L localhost:8080:localhost:5000 hpc
# And check here
# https://docs.vscentrum.be/access/ssh_config.html#how-to-set-up-a-tunnel
#!/bin/bash

# Set default mlruns directory if not provided
mlruns_dir=${1:-"/data/leuven/344/vsc34493/projects/biased_anomaly_detection/mlruns"}

# Set port numbers for local and remote
local_port=5006
remote_port=6007

# SSH into the remote machine, activate the environment, and start the MLflow server with SQLite backend
ssh -tv hpc "conda activate biased_anomaly_detection && cd ${mlruns_dir} && mlflow server --backend-store-uri sqlite:///mlruns.db --default-artifact-root file:mlruns --host 0.0.0.0 --port ${remote_port}"

# Set up SSH port forwarding from the remote machine to your local machine
ssh -fNL ${local_port}:localhost:${remote_port} hpc

# Notify the user
echo "SSH port forwarding is set up. Access the MLflow server UI at http://localhost:${local_port}."


# on cluster
#/data/leuven/344/vsc34493/projects/biased_anomaly_detection $ mlflow server --backend-store-uri sqlite:///mlruns.db --default-artifact-root file:mlruns --host 0.0.0.0 --port 5050 --workers 18
# on local
#ssh -fNL 5000:localhost:5050 hpc

# I have now started instead storing the mlruns in the scratch directory where the read/write should be faster
# Here: /scratch/leuven/344/vsc34493/mlruns

# Then look at http://localhost:5000

# Note that you might run into issues if you want to move the database and it allready exists somewhere else (Change the experiment name)
