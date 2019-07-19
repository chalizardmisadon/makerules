#!/bin/bash


# basic UI color
clrRst="\e[0m"
clrRed="\e[91m"
clrGrn="\e[92m"
clrYel="\e[93m"
clrBlu="\e[94m"


# verbose setting
verbose=false
idx=1
eval arg='$'$idx
if [[ $arg == "-v" ]]
then
	echo -e $clrGrn"Verbose"$clrRst is set
	verbose=true
	((idx++))
	eval arg='$'$idx
fi


# parse file if argument exist
fileDir=$HOME/.profile
if [[ -z $arg ]]
then
	echo -e No argument give. Default file is $clrYel$fileDir$clrRst"\r\n"
elif [[ ! -f $arg ]]
then
	echo -e File $clrRed$arg$clrRst does not exist!
	exit 1
else
	fileDir=$arg
fi


# read .profile
file=()
while read -r line;
do
	file+=("${line}")
	# echo "${line}"
done < $fileDir


# check if MAKEDIR is export
exist_COMMENT=false
exist_MAKEDIR=false
for ((i = 0; i < ${#file[@]}; i++))
do
	# verbose out the file
	if [[ $verbose == true ]]
	then
		echo ${file[i]}
	fi

	# check if MAKEDIR and COMMENT exist
	if [[ ${file[i]} == *"MAKEDIR"* ]]
	then
		exist_MAKEDIR=$i
		if [[ ${file[i-1]} == "#"* ]]
		then
			exist_COMMENT=$((i-1))
		fi
	fi
done


# print out result
echo -e "\n" $x{1..20}"=" "\n"
if [[ $exist_MAKEDIR != false ]]
then
	echo -e COMMENT: $clrGrn$exist_COMMENT$clrRst: ${file[$exist_COMMENT]}
else
	echo -e COMMENT: $clrGrn$exist_COMMENT$clrRst
fi
if [[ $exist_COMMENT != false ]]
then
	echo -e MAKEDIR: $clrGrn$exist_MAKEDIR$clrRst: ${file[$exist_MAKEDIR]}
else
	echo -e MAKEDIR: $clrGrn$exist_MAKEDIR$clrRst
fi
echo -e "\n" $x{1..20}"=" "\n"


# set string to write
echo -e Adding to $fileDir..."\r\n"
comment="# customized makefile template directory"
path="\$HOME/"$(realpath --relative-to=$HOME\
	$(dirname $(dirname $(realpath ${BASH_SOURCE[0]}))))/mk
echo -e $clrBlu$comment"\r\n"export MAKEDIR=$path"/""\r\n"$clrRst


# clear MAKEDIR if exist
if [[ $exist_MAKEDIR != false ]]
then
	file[$exist_MAKEDIR]=""
	if [[ $exist_COMMENT != false ]]
	then
		# clear COMMENT if exist
		file[$exist_COMMENT]="$comment"
		file[$exist_MAKEDIR]="export MAKEDIR=$path/"
	else
		file[$exist_MAKEDIR]="$comment\r\nexport MAKEDIR=$path/"
	fi
else
	file+=("\r\n")
	file+=("$comment\r\nexport MAKEDIR=$path/")
	exist_MAKEDIR=${#file[@]}
fi


# always create backup incase catastrophy
cp $fileDir $fileDir.backup

# write to file
printf "" > $fileDir
for ((i = 0; i < ${#file[@]}; i++))
do
	if [[ $verbose == true ]]
	then
		echo -e ${file[i]}
	fi
	echo -e ${file[i]} >> $fileDir
done