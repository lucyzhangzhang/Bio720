#!/bin/bash
if [ -e FOFN ]; then
    rm -f FOFN;
fi

ls -dv $PWD/*.* > FOFN;
while read line; do
    prefix=$(basename -- "$line");
    extension="${prefix##*.}";
    prefix="${prefix%.*}";
    echo "The prefix of the file is $prefix";
    echo "The extension of the file is $extension";
done < FOFN
rm -f FOFN;
