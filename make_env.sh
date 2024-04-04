#!/bin/bash -l
#SBATCH --qos=normal
#SBATCH --partition=standard                                       
#SBATCH --job-name setup_rosettafold
#SBATCH --mem=20G
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1             
#SBATCH --nodes=1   
#SBATCH --output=/projects/ilfgrid/people/pqh443/Git_projects/RoseTTAFold-All-Atom/temp/logs/%j_out.txt
#SBATCH --error=/projects/ilfgrid/people/pqh443/Git_projects/RoseTTAFold-All-Atom/temp/logs/%j_err.txt

# Load miniconda and mamba modules
module load miniconda
module load mamba

# Set paths to RoseTTAFold directory and where the environment should be installed
RFDIR="/projects/ilfgrid/people/pqh443/Git_projects/RoseTTAFold-All-Atom"
ENV_PATH=$RFDIR/RFAA_env
cd $RFDIR

# Set the directory for mamba to store packages, avoiding the use of your home directory
export CONDA_PKGS_DIRS=$RFDIR/.conda/pkgs

# Set the root prefix for mamba to fully isolate its operations (not always necessary)
export MAMBA_ROOT_PREFIX=$RFDIR/mamba_root

# 1. Create environment using yaml file and activate it
mamba env create -f ./environment.yaml --force --prefix $ENV_PATH 
conda activate $ENV_PATH

# 2. Install requirements for SE3Transformer using pip3
cd $RFDIR/rf2aa/SE3Transformer/
pip3 install --no-cache-dir -r requirements.txt
python3 setup.py install
cd $RFDIR

# 3. Install signalp6 - update links to your download link

# Download signalp using wget
#wget https://services.healthtech.dtu.dk/download/6ba06fcf-7b34-4837-97fd-5f1396a84ff9/signalp-6.0_license.txt
#wget https://services.healthtech.dtu.dk/download/6ba06fcf-7b34-4837-97fd-5f1396a84ff9/signalp-6.0h.fast.tar.gz

# Untar downloaded archive
#tar -xzvf signalp-6.0h.fast.tar.gz
#rm signalp-6.0h.fast.tar.gz

# Install signalp6 using pip
#cd $RFDIR/signalp6_fast
#pip install signalp-6-package/
#SIGNALP_DIR=$(python3 -c "import signalp; import os; print(os.path.dirname(signalp.__file__))" )
#echo "SignalP installed to: "
#echo $SIGNALP_DIR
#cp -r signalp-6-package/models/* $SIGNALP_DIR/model_weights/
#cd $RFDIR

# Configure signalp6 and rename distilled model weights
#signalp6-register signalp-6.0h.fast.tar.gz
#mv $ENV_PATH/lib/python3.10/site-packages/signalp6-6.0+h-py3.10.egg/signalp/ $ENV_PATH/lib/python3.10/site-packages/signalp/
#cp $RFDIR/signalp6_fast/signalp-6-package/models/distilled_model_signalp6.pt $ENV_PATH/lib/python3.10/site-packages/signalp/model_weights/ensemble_model_signalp6.pt

# 4. Install input preparation dependencies
cd $RFDIR 
bash install_dependencies.sh

# 5. Load model weights 
wget http://files.ipd.uw.edu/pub/RF-All-Atom/weights/RFAA_paper_weights.pt

# 6. Load MSA sequence databases
