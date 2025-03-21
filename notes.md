# Useful links
* https://docs.vscentrum.be/en/latest/antwerp/SLURM_UAntwerp.html?highlight=slurm#slurm-concepts
* https://docs.vscentrum.be/en/latest/antwerp/SLURM_convert_from_PBS.html?highlight=slurm
* https://slurm.schedmd.com/overview.html
* https://vsoch.github.io/lessons/sherlock-jobs/

# Team data repository
Provided you have access, you can find the teams data here
```
/lustre1/project/stg_00078
```

# Setup mlflow dashboard to be viewed locally port forwarding

When logged into cluster start the mlflow server on the default port 5000 by running the line below when you are in the directory contraining the "mlruns" folder:
(Keep in mind that you might need to activate a conda environment with mlflow installed first)
```
mlflow ui
```

Then on your local machine forward the port to your local machine:
Make sure to kill all processes on the cluster: ```kill $(lsof -t -i:5000)```
```
ssh -L 5000:localhost:5000 hpc
```

Then you can view the mlflow dashboard at http://localhost:5000

If someething does not work rather start from scratch and kill everything.


## Or if the cluster is not busy:
### on cluster
Mlruns in the scratch directory where the read/write should be faster You might actually have to be outside of the directory?
#/scratch/leuven/344/vsc34493/mlruns $ mlflow server --backend-store-uri sqlite:///mlruns.db --default-artifact-root file:mlruns --host 0.0.0.0 --port 5050 --workers 18

# or if it is not sqlite, but just files inside the project directory
mlflow server --backend-store-uri file:///data/leuven/344/vsc34493/mlruns --default-artifact-root /data/leuven/344/vsc34493/mlruns --host

### on local
`ssh -fNL 5000:localhost:5050 hpc`
Then look at http://localhost:5000

Note that you might run into issues if you want to move the database and it allready exists somewhere else (Change the experiment name)

### Copyting with rsync and viewing locally for mlruns
One things that seems to be working quite well is run the mlflow server locally and to sync the data using rsync
```
rsync -av --ignore-existing -e ssh hpc:/data/leuven/344/vsc34493/projects/biased_anomaly_detection/mlruns ~/Downloads  
```
-a is for archive mode so that the same timestamps are kept
--ignore-existing is to not unnecessarily copy files that are already there

### Alternatively you can copy the data over using rsync

[//]: # (rsync -avz -e ssh hpc:/data/leuven/344/vsc34493/projects/biased_anomaly_detection ~/Downloads)
rsync -avz --progress -e ssh hpc:/data/leuven/344/vsc34493/projects/biased_anomaly_detection ~/Downloads



# Extensions
It can make sense to add appending the path of the current directory to the PYTHONPATH variable. This can be done by adding the following line to the top of the jobscript:
This will allow the src folder to be imported as a module.

```
export PYTHONPATH=$PYTHONPATH:$(pwd)
```
# Packages are managed by conda
## Conda installation for VSC
This means that a Conda distribution is required

https://vlaams-supercomputing-centrum-vscdocumentation.readthedocs-hosted.com/en/latest/software/python_package_management.html


```
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -b -p $VSC_DATA/miniconda3
export PATH="${VSC_DATA}/miniconda3/bin:${PATH}"
```

## Creating environments 
Idea is to manually create `environment.yml` files that can be easily installed using 

```
conda env create -f environment.yml
```

# Databases with MongoDB

Idea is to run the mongodb database using a docker container https://hub.docker.com/_/mongo/.

In structions for running contrainers on VSC can be found here: https://docs.vscentrum.be/en/latest/software/singularity.html


VSC uses `podman` instead of `docker` but they seem to be interchangeable.

Install the docker image and run it as a container.
A container is a running instance of an image.


```
podman run --name vsc-mongo -d -p 27017:27017 -v $VSC_DATA/data/db mongo 

podman start vsc-mongo # This is for when the mongo process exists already 
```

* -p 27017:27017: Expose the port 27017 of the container to the host. Important for later connecting with ```pymongo.MongoClient("mongodb://localhost:27017/")```
* -v YOUR_LOCAL_DIR:/data/db: Mount the local directory to the container. This is important for persisting the data. If you don't do this, the data will be lost when the container is stopped.

To get interactive mongo shell:
```
podman exec -it vsc-mongo bash
mongosh
```

To show the running docker containers 

```
podman ps --all
```

# Troubleshooting with HPC
# Interactive session using slurm 
```
srun --nodes=1 --ntasks-per-node=1 --time=02:00:00 --cluster=genius --account=lleuven_phm --pty bash -i
```

If you want to run a python scipt you might have to activate the conda environment and set the PYTHONPATH

```
conda activate biased_anomaly_detection
export PYTHONPATH=$PYTHONPATH:.
```

## Restore your bashrc to default
```
/bin/cp /etc/skel/.bashrc ~/ # This will overwrite your current bashrc
``` 

 # Hacks and simplifications 

## Delete many outputs
 If you want to delete the outputs of many job scripts during development, you can use

 ```
 rm some_jobscript_name.pbs.*  
 ```

Make sure to have the "." otherwise you will delete the script itself

## You can test you .pbs scrips in an interactive session
This is perhaps not a hack but it is a good way to test your scripts before submitting them to the queue. 

Modify the permissions of the script to make it executable
```
chmod +x some_jobscript_name.pbs
```

Then run the script in an interactive session
```
./some_jobscript_name.pbs
```

## How to submit jobs where one of the jobs depends on the other

For example, if you need to compress data after running many jobs.

https://bioinformaticsworkbook.org/Appendix/HPC/SLURM/submitting-dependency-jobs-using-slurm.html#gsc.tab=0
```
sbatch --dependency=afterok:12345 myjob.pbs
```

```
JOBID1=$(sbatch --parsable <other_options> <submission_script>)
JOBID2=$(sbatch --dependency=afterok:$JOBID1 <other_options> <submission_script>)

sbatch --dependency=afterok:$JOBID1,$JOBID2 <submission_script>
```


# Configuration file for connecting to the VSC

~/.ssh/config

```
Host hpc                                                                                                                                                                                  
	HostName login.hpc.kuleuven.be
	User vsc34493
	IdentityFile ~/.ssh/id_rsa_vsc
```
# Copying data
## Copying folder with data to the cluster using the vsc alias
```
scp -r /home/douwm/data/cache/cwr hpc:/data/leuven/344/vsc34493/data/cache
```

## Copying results from the cluster to local machine
```
scp hpc:/vsc-hard-mounts/leuven-data/344/vsc34493/projects/biased_anomaly_detection/results.pkl .
```


## Copy data from ```$VSC_DATA``` to ```$VSC_SCRATCH```
```
cp -r /data/leuven/344/vsc34493/data /scratch/leuven/344/vsc34493
```

# Check what a job cost
```
sam-list-usagerecords --account=lp_my_project --start=2023-01-01 --end=2023-01-31
```

Possibly it could make sense to add dayly limites 
https://slurm.schedmd.com/resource_limits.html


# Monitoring jobs
Use ```squeue``` to see if the jobs are running/submitted
```
squeue
```

Then you can read off the node and ssh into it to see what is happening
```
ssh r26i13n12
```

Then you can use ```top```  or ```htop``` to see what is happening on the node