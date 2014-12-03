
#!/bin/bash

# submit n jobs to run fusion
# n defines number of jobs in total
# Input Arguments: 
#   1.vegetation index
#   2.path
#   3.file pattern
#   4.n jobs

echo 'Total jobs to submit is' $4
for i in $(seq 1 $4); do
    echo 'Submitting job no.' $i 'out of' $4
    chmod u+x ./submit_job.sh
    qsub ./submit_job.sh $1 $2 $3 $4 $i 
done

# end
