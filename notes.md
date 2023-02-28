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