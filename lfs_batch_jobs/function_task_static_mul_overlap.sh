#!/bin/bash
export LSB_JOB_REPORT_MAIL=N
experiment_name='function_task_static_mul_overlap'
operation=mul
overlap_ratios=( 0.0 0.1 0.25 0.5 0.75 1.0 )
verbose_flag=''
for seed in {0..9}
do
    for overlap_ratio in "${overlap_ratios[@]}"
    do
        bsub -q compute -n 8 -W 14:00 -J ${experiment_name} -o /work3/$USER/logs/${experiment_name}/ -e /work3/$USER/logs/${experiment_name}/ -R "span[hosts=1]" -R "rusage[mem=10GB]" ./python_lfs_job.sh \
            experiments/simple_function_static.py --overlap-ratio ${overlap_ratio} \
            --operation ${operation} --layer-type NAC --nac-mul normal \
            --seed ${seed} --max-iterations 5000000 ${verbose_flag} \
            --name-prefix ${experiment_name} --remove-existing-data

        bsub -q compute -n 8 -W 14:00 -J ${experiment_name} -o /work3/$USER/logs/${experiment_name}/ -e /work3/$USER/logs/${experiment_name}/ -R "span[hosts=1]" -R "rusage[mem=10GB]" ./python_lfs_job.sh \
            experiments/simple_function_static.py --overlap-ratio ${overlap_ratio} \
            --operation ${operation} --layer-type PosNAC --nac-mul normal --first-layer NAC \
            --seed ${seed} --max-iterations 5000000 ${verbose_flag} \
            --name-prefix ${experiment_name} --remove-existing-data

        bsub -q compute -n 8 -W 14:00 -J ${experiment_name} -o /work3/$USER/logs/${experiment_name}/ -e /work3/$USER/logs/${experiment_name}/ -R "span[hosts=1]" -R "rusage[mem=10GB]" ./python_lfs_job.sh \
            experiments/simple_function_static.py --overlap-ratio ${overlap_ratio} \
            --operation ${operation} --layer-type NALU \
            --seed ${seed} --max-iterations 5000000 ${verbose_flag} \
            --name-prefix ${experiment_name} --remove-existing-data

        bsub -q compute -n 8 -W 14:00 -J ${experiment_name} -o /work3/$USER/logs/${experiment_name}/ -e /work3/$USER/logs/${experiment_name}/ -R "span[hosts=1]" -R "rusage[mem=10GB]" ./python_lfs_job.sh \
            experiments/simple_function_static.py --overlap-ratio ${overlap_ratio} \
            --operation ${operation} --layer-type ReRegualizedLinearNAC --nac-mul mnac \
            --seed ${seed} --max-iterations 5000000 ${verbose_flag} \
            --name-prefix ${experiment_name} --remove-existing-data
    done
done
