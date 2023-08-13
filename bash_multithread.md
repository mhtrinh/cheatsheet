Mostly from chatGPT :D
```bash
#!/bin/bash

todo_file="/dev/shm/vqz.list"
done_dir="/dev/shm/done"

log_dir=".logs.$$"
error_log="$log_dir/error.log"
max_parallel=4  # Set the maximum number of parallel processes

if [ $# -lt 1 ]; then
    echo "Usage: $0 <path to root folder of vqzs>"
    exit 1
fi
root_dir=$1

mkdir -p "$log_dir"
mkdir -p "$done_dir"

echoLog (){
    echo "$(date): $@"
}


lock() {
    touch $1.lock
}

unlock() {
    rm -f $1.lock
}

get_worker_id(){
    for i in $(seq 1 $max_parallel); do
        if [ ! -f $i.lock ]; then
            echo $i
            return 0
        fi
    done
    return 1
}


process_one() {
    path=$1
    echoLog "Processing: $path"
    python3 runme.py "$root_dir" "$path"
    res=$?
    if [ $res -ne 0 ]; then
        return $res
    fi
    return 0
}


run_task() {
    local argument="$1"
    local worker_id="$2"
    local log_file="$log_dir/worker_$worker_id.log"
    echoLog "$log_file: $argument"
    process_one "$argument" >> "$log_file" 2>&1
    if [ $? -ne 0 ]; then
        echoLog "$log_file: ERROR processing $argument" | tee -a  $error_log
    fi
}

# Function to clean up and exit gracefully
clean_exit() {
    echoLog "Cleaning up..."
    trap - INT  # Remove the interrupt trap
    # Kill all background processes
    for job in $(jobs -p); do
        kill "$job"
    done
    wait  # Wait for all processes to terminate
    echoLog "All tasks have been stopped."
    exit
}

# Set up the interrupt trap
trap clean_exit INT

main ()
{
    # Get vqz list :
    find $root_dir -type f -iname "*.vqz" > $todo_file

    # Counter for tracking the number of active background processes
    local active_jobs=0
    local worker_id=1

    # Read the input file line by line
    exec 9< "$todo_file"
    while IFS= read -r -u 9 argument; do
        # Wait if the maximum number of parallel processes is reached
        active_jobs=$(jobs -p | wc -l)
        while [ "$active_jobs" -ge "$max_parallel" ]; do
            wait -n
            active_jobs=$(jobs -p | wc -l)
        done

        worker_id=$(get_worker_id)
        # Run the task in the background with the worker ID and increment counters
        (
            lock $worker_id
            run_task "$argument" "$worker_id"
            unlock $worker_id
        ) &

    done

    # Wait for all background processes to finish
    echoLog "Waiting for last workers to finish ..."
    wait

    echoLog "All tasks have completed."
}


main |& tee -a $log_dir/main.log
