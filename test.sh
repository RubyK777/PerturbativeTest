#!/bin/bash
#SBATCH --output=positive_DC1_9914_1e-3.out
#SBATCH --time=06:00:00
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=r7kong@uwaterloo.ca

module load octave

octave --silent --no-gui test.m
