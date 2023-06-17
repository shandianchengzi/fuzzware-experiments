#!/bin/bash
DIR="$(dirname "$(readlink -f "$0")")"

# TARGET_LIST="P2IM/CNC P2IM/Drone"
TARGET_LIST="P2IM/Heat_Press P2IM/Reflow_Oven P2IM/Soldering_Iron P2IM/Console P2IM/Gateway P2IM/PLC P2IM/Robot P2IM/Steering_Control"
TARGET_LIST="$TARGET_LIST uEmu/6LoWPAN_Receiver uEmu/6LoWPAN_Sender uEmu/RF_Door_Lock uEmu/Thermostat uEmu/XML_Parser uEmu/LiteOS_IoT uEmu/Zepyhr_SocketCan uEmu/utasker_MODBUS uEmu/utasker_USB uEmu/uEmu.3Dprinter uEmu/uEmu.GPSTracker"

# Running this configuration in an unmodified way sequentially will take ~210 days of real-time computation
experiment_repetition_count=5
target_list=$TARGET_LIST

echo "running with run_with_modeling=$run_with_modeling, experiment_repetition_count=$experiment_repetition_count, num_parallel_procs=$num_parallel_procs, fuzzing_runtime=$fuzzing_runtime"

project_base_name="fuzzware-project"
statistics_names="coverage crashcontexts"

( for run_no in `seq 1 $experiment_repetition_count`; do
    project_name=$(printf ${project_base_name}-run-%02d $run_no)
    echo $project_name

    for target in $target_list; do
        fuzzware genstats -p $DIR/$target/$project_name $statistics_names
    done
done ) 
$DIR/run_metric_aggregation.py
