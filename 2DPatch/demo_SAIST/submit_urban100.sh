#!/bin/bash

for i in $(seq $1 $2)
do
    qsub -v PBS_ARRAYID=$i saist_urban100.pbs
done
