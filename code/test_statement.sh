#!/bin/bash
#test_statement.sh


[ -w test.txt ]
echo $? #false 1



#[ -w $1 -a $2 ]
#echo $?

str2=
[ -n $str2 ]
echo $? #0
[ -n "$str2" ] 
echo $? #1

echo "------"
      
var1=hello
var2=hello

[ var1 = var2 ]
echo $?
[ $var1 = $var2 ]
echo $?
[ "$var1" = "$var2" ]
echo $?

echo

[ "2" -eq "2" ]
echo $? #0


echo 
[ 0 ] #0
echo $?
[ -1 ] #0
echo $?
[ 1 ] #0
echo $?
[  ]
echo $?






