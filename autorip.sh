#!/bin/bash

# set -o xtrace

DEVICE=$1
ROOT_OUTPUT_FOLDER=$2

usage(){
    echo -e "USAGE: \nautorip DEVICE ROOT_OUTPUT_FOLDER"
    echo
    echo ".iso files will be placed into child folders based on disk names"
}

get_disk_name(){
    cmd="blkid -o value -s LABEL $DEVICE"
    until $cmd > /dev/null; do
        sleep 1
    done
    $cmd
    return $?
}

parse_disk_name_and_create_directories(){
    input=$1

    season=`echo $input | grep -Po 'S(EASON)?[0-9]+'`
    disk=`echo $input | grep -Po 'D(ISK)?[0-9]+'`

    pattern=''
    if [[ -n $season ]]; then
        pattern=$pattern"_$season"
    fi
    if [[ -n $disk ]]; then
        pattern=$pattern"_?$disk"
    fi
    show=`echo $input | grep -oP ".+(?=$pattern)"`

    path=$ROOT_OUTPUT_FOLDER/`to_lowercase $show/$season`

    mkdir -p $path
    if [[ $? != 0 ]]; then
        echo "FATAL: Coult not make directory '$path'"
        return 1
    fi
    echo $path
    return 0
}

to_lowercase(){
    echo $1 | tr '[:upper:]' '[:lower:]'
    return 0
}

rip_disk(){
    disk_name=`get_disk_name`
    echo "Disk name: $disk_name"

    directory=`parse_disk_name_and_create_directories $disk_name`
    if [[ $? != 0 ]]; then
        exit 1
    fi
    echo "Directory: $directory"

    file_name=$directory/`to_lowercase $disk_name`.iso
    echo "File: $file_name"

    if [[ $DEVICE == "" || $file_name == "" ]]; then
        echo "ERROR: Device or file_name is empty. Device: '$DEVICE', file_name: '$file_name'"
        echo "Refusing to run dd"
        return 1
    fi
    
    if [[ -e $file_name ]]; then
        echo "ERROR: Output file already exists! Refusing to overwrite."
        return 1
    fi

    dd if=$DEVICE of=$file_name
    return_code=$?
    if [[ $return_code != 0 ]]; then
        echo "dd failed - attempting with ddrescue..."
        ddrescue -nN $DEVICE $file_name "$disk_name"_mapfile
        return_code=$?
    fi

    return $return_code

}

main(){
    if [[ $DEVICE == '' || $ROOT_OUTPUT_FOLDER == '' ]]; then
        usage
        exit 1
    fi

    while true; do
        rip_disk
        sleep 1
        eject $DEVICE
        echo "Insert next disk..."
        tput bel
    done

    return 0
    
}

main
