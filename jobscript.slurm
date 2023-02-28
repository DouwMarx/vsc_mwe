#! /bin/bash
#
#SBATCH --cluster=wice # The compute cluster to use. Genius will do the trick for most things.
#SBATCH --account=lleuven_phm # Account to charge (Provided you have access). Use resources responsibly.
#SBATCH --job-name=vsc_mwe  # Name will appear together with job id. Don't use spaces.
#SBATCH --ntasks=1 # Asks srun to allocate resources for ntasks tasks. Works together with --cpus-per-task.
#SBATCH --cpus-per-task=10 # N cpus per task. Check max for harware. i.e. 32 for Genius cluster.
#SBATCH --mem=2g # Memory required per node
#SBATCH --time=00:05:00 # Time expected from run hrs:min:sec . Set as small as possible.

# Load required modules
 module --force purge # First purge all modules
# module load some_module

# Copy data you need to scratch drive, bearing in mind that it will be deleted at some point.
# cp -r /lustre1/project/stg_00078/IMS $VSC_SCRATCH

# Tell conda where to find the python libraries you have installed conda in a conda environment and activate the environment
# >>> conda initialize >>> # This is the conda intialisation that is added by default by conda.
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/data/leuven/344/vsc34493/miniconda/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$VSC_DATA/miniconda/etc/profile.d/conda.sh" ]; then
        . "$VSC_DATA/miniconda/etc/profile.d/conda.sh"
    else
        export PATH="$VSC_DATA/miniconda/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

conda activate vsc_mwe # Activate conda enviroment

# Run the python script
python example_script.py


