#!/bin/bash

app_name="GreenCape Gitar"
app_version="0.1.0"
tar_options="--atime-preserve=system --preserve-permissions --same-owner"

export GIT_OBJECT_DIRECTORY="$PWD/.git-objects"

# Name of the temporary directory
directory="backup."$$".tmp.d"

usage () {
    echo ""
    echo "Usage: "$(basename $0)" [-b|-r] [options]"
    echo ""
    echo "Operation mode"
    echo "  -b, --backup"
    echo "                 Perform backup (default)"
    echo "  -r, --restore"
    echo "                 Restore backup"
    echo "  -u, --update"
    echo "                 Add changes to backup"
    echo ""
    echo "Options"
    echo "  -a, --archive=filename"
    echo "                 The filename of the dump."
    echo "                 If ommitted, the directory is only compressed."
    echo "  -c, --comment"
    echo "                 Comment on the current update"
    echo ""
    echo "  -h, --help"
    echo "                 Show this messsage"
    echo "  -v, --verbose"
    echo "                 Show more output"
    echo ""
}

# Get option arguments
INPUT=$(getopt --n "$(basename $0)" -o a:bc:hruv --long "archive:,backup,comment:,help,restore,update,verbose" -- "$@")

if [ $? -ne 0 ]
then
    exit 1
fi
eval set -- "$INPUT"

has_error="no"
verbose="no"
operation="backup"
message="$(date +'%F-%H-%M-%S')"

while true
do
    case "$1" in
        -b|--backup)
            operation="backup"
            shift
            ;;
        -r|--restore)
            operation="restore"
            shift
            ;;
        -u|--update)
            operation="update"
            shift
            ;;
        -a|--archive)
            archive=$2
            shift 2
            ;;
        -c|--comment)
            message=$2
            shift 2
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        -v|--verbose)
            verbose="yes"
            tar_options="$tar_options --verbose"
            shift
            ;;
        --)
            shift
            break
            ;;
        *) # unknown
            has_error="yes"
            shift
            break
            ;;
    esac
done

# Error check
if [ "$has_error" == "yes" ]
then
    usage
    exit 1
fi

echo -e "$app_name $app_version\n"



if [ "$verbose" == "yes" ]; then echo -e "\nDone."; fi
