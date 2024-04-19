#SBATCH --partition=standard
#SBATCH --qos=normal
#SBATCH --job-name=RFAA_MSA
#SBATCH --mem=64G
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --nodes=1
#SBATCH --output=/projects/ilfgrid/apps/RoseTTAFold-All-Atom/temp/logs/%j_out.txt
#SBATCH --error=/projects/ilfgrid/apps/RoseTTAFold-All-Atom/temp/logs/%j_err.txt

module load miniconda
conda activate /projects/ilfgrid/apps/RoseTTAFold-All-Atom/mamba_env

# Inputs
in_fasta="$1"

# Output directory for the MSA files
out_dir="$2"

# Check if in_fasta ends with .txt, and if it does, use SLURM_ARRAY_TASK_ID to get the fasta file
if [[ $in_fasta == *.txt ]]; then
    in_fasta=$(sed -n "${SLURM_ARRAY_TASK_ID}p" $in_fasta)
fi

# Make sure in_fasta is a fasta file – ends with either .fa or .fasta
if [[ $in_fasta != *.fa && $in_fasta != *.fasta ]]; then
    echo "Error: Input file is not a fasta file"
    exit 1
fi

# Build output directory path from input fasta file
base=$(basename $in_fasta)
base=${base%.*}
out_dir=$out_dir/$base

# Resources
CPU=4
MEM=64

# Path to the template database
DB_TEMPL="/projects/ilfgrid/apps/RoseTTAFold-All-Atom/pdb100_2021Mar03/pdb100_2021Mar03"

# Launch the MSA preparation script
bash /projects/ilfgrid/apps/RoseTTAFold-All-Atom/make_msa.sh $in_fasta $out_dir $CPU $MEM $DB_TEMPL
