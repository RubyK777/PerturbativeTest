#!/bin/bash
#SBATCH --job-name=Ground_N_CBBK
#SBATCH --time=06:00:00
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=r7kong@uwaterloo.ca

module load octave

octave --silent --no-gui test_2.m
