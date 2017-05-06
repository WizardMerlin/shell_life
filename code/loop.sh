#!/bin/bash
#loop.sh


for var in a b c; do
    echo "var = $var"
done

echo "-------------"

for filename in $(ls); do
    if [ -f "$filename" ]; then
	echo "$filename is a file"
    elif [ -d "$filename" ]; then
	echo "$filename is a directory"
    else
	echo "unknow"
    fi
done

echo "plz input sth"
read try
while [ "$try" != "ok" ] ; do
    echo "plz input ok"
    read try
done


#exit 0; #说明shell和shell脚本之间是调用关系
return 0;



