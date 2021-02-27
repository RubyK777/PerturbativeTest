#!/bin/bash
#SBATCH --account=def-nike-ab
#SBATCH --output=negative_DC2_12914_1e-6.out
#SBATCH --job-name=perturbative_test
#SBATCH --time=02:00:00
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=r7kong@uwaterloo.ca

module load octave

octave --silent --no-gui perturbative_test.m
