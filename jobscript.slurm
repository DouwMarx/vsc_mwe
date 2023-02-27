#! /bin/bash
#
#SBATCH --account=lleuven_phm # Account to charge (Provided you have access). Use resources responsibly.
#SBATCH --job-name=vsc_mwe  # Name will appear together with job id. Don't use spaces.
#SBATCH --ntasks=1 # Asks srun to allocate resources for ntasks tasks. Works together with --cpus-per-task.
#SBATCH --cpus-per-task=10 # N cpus per task. Check max for harware. i.e. 32 for Genius cluster.
#SBATCH --mem=2g # Memory required per node
#SBATCH --time=00:05:00 # Time expected from run hrs:min:sec . Set as small as possible.

# Load required modules
# module --force purge # First purge all modules
# module load some_module


# Copy the data to the local scratch
# cp -r $VSC_DATA/projects/vsc_setup $TMPDIR

# >>> conda initialize >>> # This is the conda intialisation that is added by default by conda.
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/data/leuven/344/vsc34493/miniconda/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/data/leuven/344/vsc34493/miniconda/etc/profile.d/conda.sh" ]; then
        . "/data/leuven/344/vsc34493/miniconda/etc/profile.d/conda.sh"
    else
        export PATH="/data/leuven/344/vsc34493/miniconda/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Activate the conda environment
export PATH="/data/leuven/344/vsc34493/miniconda/bin:$PATH" #Location of the python libraries you have installed using conda
conda activate vsc_mwe

# Run the python script
python example_script.py


