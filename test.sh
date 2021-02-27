#!/bin/bash
#SBATCH --account=def-nike-ab
#SBATCH --output=negative_DC1_9914_1e-3.out
#SBATCH --job-name=perturbative_test
#SBATCH --time=02:30:00
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=r7kong@uwaterloo.ca

module load octave

octave --silent --no-gui perturbative_test.m
