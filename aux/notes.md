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

# Setup mlflow dashboard to be viewed locally.

When logged into cluster start the mlflow server on the default port 5000 by running the line below when you are in the directory contraining the "mlruns" folder:
(Keep in mind that you might need to activate a conda environment with mlflow installed first)
```
mlflow ui
```

Then on your local machine forward the port to your local machine:
```
ssh -L 5000:localhost:5000 hpc
```

Then you can view the mlflow dashboard at http://localhost:5000

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
## Run an interactive node to troubleshoot
```
qsub -I -A lleuven_phm -l walltime=2:00:00
```
  Optionally add  # -l walltime=2:00:00

## Restore your bashrc to default
```
/bin/cp /etc/skel/.bashrc ~/ # This will overwrite your current bashrc
``` 


# Questions 
 * How to make sure that you don't have to download the docker container every time you have a new session on a node?


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



