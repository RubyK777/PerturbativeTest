#!/bin/bash
#SBATCH --account=def-ruby1
#SBATCH --job-name=perturbative_test
#SBATCH --time=00:01:00
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=r7kong@uwaterloo.ca

module load octave

ocatve - nodisplay -nosplash -nojvm -r perturbative_test
