#!/bin/bash
# Created by: Konstantinos Vaggelakos
# Date: 2011-06-08
# Use it with care!

function search {
    #Use printMsg function to colorize output
    printMsg "green" "Searching for double mkv files..."
    #Initilize found variable with false so we can check for true if we found anything later
    found=false
    # Get all subdirectories without trailing slash
    DIRS=$(echo $1| sed 's/\/*$//')/*

    #Loop through the DIRS var to search for double mkv posts
    for loop in $DIRS   do
        #Replace all spaces within directory names with backslash space
        dir=$(echo $loop| sed 's/ /\ /g')
        #If greater than 1 we must get rid of 1 or more mkvs
        if [ `find "$dir" -maxdepth 1 -type f -name "*.mkv" | wc -l` -gt 1 ]; then
            #Set found to true since we found something
            found=true
            #Search for mkv files within the directory and only those files that are 1.5GB or less.
            #If found execute rm and ask for permission to delte the file
            find "$dir" -type f -size -1500M -name "*.mkv" -exec rm -i {} \;
        fi
    done

    if $found; then
        printMsg "green" "Cleansed!"
    else
        printMsg "green" "No directories with double mkv files where found!"
    fi
}

function printMsg {
    if [ $1 = "green" ]; then
        echo -e "\e[0;32m$2 \e[m"
    elif [ $1 = "red" ]; then
        echo -e "\e[0;31m$2 \e[m"
    else
        echo -e $2
    fi
}

# Check that parameter have been passed
if [ -z $1 ]; then
    echo "Usage: $0 {PATH_TO_VIDEOS}"
    exit
fi

#Run the search function
search $*