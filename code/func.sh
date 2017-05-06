#!/bin/bash
#func.sh

func(){
  echo "function calling."
}

echo "start call func"

func

echo "func called"

#------------------------
func1(){
  echo "function calling."
  echo "$0"
  echo "$1"
  echo "$2"
}


echo "start call func1"

#pass argument
func1 a b c

echo "func1 called"


#############
echo "-------------------"
is_directory(){

  DIR_NAME=$1
  if [ ! -d $DIR_NAME  ] ; then
     return 1
  else
     return 0
  fi
     
}

for DIR in "$@"; do
    if is_directory "$DIR" ; then
       echo "$DIR is a directory,already exists"
    else
       echo "$DIR does not exist, create it"
       mkdir "$DIR" > /dev/null 2>&1
       if [ $? -ne 0  ] ;then
       	  echo "create directory failed"
	  return 1
       fi
    fi
done