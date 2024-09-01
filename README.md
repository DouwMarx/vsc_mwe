# vsc_mwe
Minimal working example for submitting job to vsc. Uses conda to manage a python environment.

## Submitting a job
For slurm use
```
sbatch jobscript.slurm
```

to run the jobscript.

## Running an interactive session
srun --nodes=1 --ntasks-per-node=1 --time=01:00:00 --cluster=wice --account=lleuven_phm --pty bash -i


## Looking at job status
``` 
squeue -u $USER
```

```
squeue -M wice
```
It seems that you have to specify the cluster to see the jobs.

## 

## Calculating compute cost
Credit info is available here https://docs.vscentrum.be/leuven/credits.html but I don't think this holds for academic users.
In the slides it says roughly 10 credits per core hour per node. 
3.5 Euro for 1000 credits.