#!/bin/bash

logo() {
	echo "========================================================================="
	echo "                           B O M     C L E A N E R                       "
    echo "                            Privided by Sloriac                          "   
	echo "========================================================================="
}

usage() {
	logo
	echo "Usage : " $0 "-a <action> -d <dir> "
    echo
    echo " Where <action> can be one of this: "
    echo "    list List all files with bom under the specfic directory."
	echo "    remove Remove bom from the files."
    echo " The rest of parameters indicates the following information :"
	echo "    -d <dir> The directory you want to process."
	echo "========================================================================="
    exit -1
}

if [ $# -lt 1 ]; then
	usage
	exit 1
fi

logo

# Deals with operation mode 
# Parses command line parameters.
while getopts "a:d:" opt; 
do
    case $opt in
        a) action=$OPTARG ;;
        d) dir=$OPTARG ;;
    esac
done

if [ -z $action ]; then
    echo "No action provided. Please write some value in parameter -u..."
    exit 1
fi

if [ -z $dir ]; then
    echo "No directory provided. Please write some value in parameter -d..."
    exit 1
fi

echo "The following parameters being used..."
echo "Action: " $action
echo "Dir: " $dir

case "$action" in
    list)
        echo "Files with bom are listed as follows :"
        grep -r -I -l $'^\xEF\xBB\xBF' $dir
    ;;

    remove)
        find . -type f -exec sed -i 's/\xEF\xBB\xBF//' $dir/* \;
    ;;
esac

exit 0
