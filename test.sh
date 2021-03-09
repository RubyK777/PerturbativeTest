#!/bin/bash
#SBATCH --time=06:00:00
#SBATCH --job-name=testFunction
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=r7kong@uwaterloo.ca

module load octave

srun octave -nodisplay -singleCompThread -r "FindReqdDelta(1e-3,1,'all_cubics',1e-308,1e-307,'P(3->2)DC2',1)"
