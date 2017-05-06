#!/bin/bash
#switch.sh

#!/bin/bash
#menu.sh

if :; then
   echo "always true";
fi


echo "--------"

echo "1. save"
echo "2. load"
echo "3. exit"

echo  #输出换行符
echo "plz choose"
read choice

case $choice in
     1)
	echo "u choose 1.save";;
     2)
        echo "u choose 2.load";;
 3 | e)
	echo "u choose 3 or exit";;
     *)
	echo "invalid choice"
        exit 1;;
esac
exit 0
