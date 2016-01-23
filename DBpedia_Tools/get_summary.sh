#!/bin/sh

dir="summary"
num=500
self="get_summary.sh"
files=$(ls)

if [ ! -d "$dir" ]; then
	echo "Folder '$dir' doesn't exists. Run mkdir..."
	mkdir "$dir"
fi

for file in $files
    do
        if [ "$file" != "$self" ]; then
            head -n "$num" "$file" > "$dir"/"$file"_head
            tail -n "$num" "$file" > "$dir"/"$file"_tail
        fi
    done