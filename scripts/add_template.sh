#!/bin/bash

# script name
bashFile=$(basename ${BASH_SOURCE[0]})

# basic UI color
clrRst="\e[0m"
clrRed="\e[91m"
clrGrn="\e[92m"
clrYel="\e[93m"
clrOrg="\e[33m"
clrBlu="\e[94m"
clrMgt="\e[95m"
clrBlk="\e[30m"
bgrGry="\e[47m"
bgrGrn="\e[48;5;82m"

# verbose setting
# verbose=false
# idx=1
# eval arg='$'$idx
# if [[ $arg == "-v" ]]
# then
# 	echo -e $clrGrn"Verbose"$clrRst is set
# 	verbose=true
# 	((idx++))
# 	eval arg='$'$idx
# fi

# if [[ $0 ]]




# print UI
if [[ -z $@ ]]; then
	echo supported source folder templates:
	echo -e "  "$clrGrn-c$clrRst"   for C"
	echo -e "  "$clrYel-cpp$clrRst" for C++"
	echo -e "  "$clrBlu-py$clrRst"  for Python"
	
	usage="usage: $bashSrc "
	echo "$usage<template[=folderName]>"
	# printf " %.0s" $(seq 1 ${#usage})
	# echo "[-s <symbolic link path>]"
	exit 0
fi


# template vars
tempPre=src_
tempSuf=_template
bashPath=$(realpath ${BASH_SOURCE[0]})
tempPath=$(dirname $(dirname $bashPath))


# copy language template
for arg in $@
do
	tempArg=${arg#-}						#; echo $tempArg
	tempLng=${tempArg%%=*}					#; echo $tempLng

	tempDir=$tempPre$tempLng$tempSuf		#; echo $tempDir
	tempSrc=$tempPath/$tempDir				#; echo $tempSrc

	if [[ $tempArg == *"="* ]]; then
		tempDst=${tempArg#*=}				#; echo $tempDst
	fi

	printf $clrOrg[${arg%%=*}]$clrRst", "
	cmdArg="[${arg%%=*}], "
	tabLen=$(seq ${#cmdArg})
	tabSpc=$(printf " %.0s" $tabLen)
	tabPrn=""

	case $tempLng in
	c | cpp | py)

		# check =folderName
		if [[ $tempDst == "" ]]; then
			tempDst=$tempDir				#; echo $tempDst
		fi

		if [[ ! -d $tempSrc ]]; then
			echo -e Option $clrYel${arg%%=*}$clrRst\
					is missing template $clrRed$tempDir$clrRst!
			echo -e "$tabSpc"Please create template $clrBlu$tempSrc$clrRst
			exit 1
		elif [[ -d $PWD/$tempDst ]]; then
			echo -e Folder $clrRed$tempDst$clrRst already exist!
			exit 2
		else
			echo -e Creating folder $clrGrn$tempDst$clrRst\
					from template $clrYel$tempDir$clrRst ...
			cp -rf $tempSrc $PWD/$tempDst
		fi
	;;
	s)
		# check symbolic link arg
		if [[ $tempDst == "" ]]; then
			tempDst=$PWD
			echo Creating symbolic link in current directory...
			tabPrn=$tabSpc
		fi

		# evaluate ~ symbol through command line
		eval tempDst=$(printf $tempDst)

		# check for valid dir and file not exist
		if [[ ! -d $tempDst ]]; then
			echo -e "$tabPrn"Argument $clrRed$tempDst$clrRst is not a valid directory!
			exit 3
		fi
		linkDst=$(realpath $tempDst/$bashFile)
		if [[ -f $linkDst ]]; then
			echo -e "$tabPrn"File $clrRed$linkDst$clrRst already exist!
			exit 2
		else
			echo -e "$tabPrn"Creating symbolic link $clrGrn$linkDst$clrRst
			tabPrn=$tabSpc
			echo -e "$tabPrn"from source file $clrBlu$bashPath$clrRst ...
			ln -s $bashPath $tempDst
		fi
	;;
	*)
		echo -e Option $clrRed${arg%=*}$clrRst is not yet supported!
	;;
	esac
done

# fileDir=$HOME/scripts
# if [[ -z $arg ]]
# then
# 	if [[ $verbose == true ]]
# 	then
# 		echo -e No argument give. Default script directory is $clrYel$fileDir$clrRst"\r\n"
# 	fi
# elif [[ ! -d $arg ]]
# then
# 	# create dir if not exist
# 	if [[ $verbose == true ]]
# 	then
# 		echo -e Directory $clrRed$arg$clrRst does not exist!
# 	fi
# 	fileDir=$arg
# 	mkdir $fileDir
# fi


# # create symbolic link for this file
# rm -f $HOME/bin/addC_template.sh
# echo $(realpath ${BASH_SOURCE[0]})
# ln -s ${BASH_SOURCE[0]} $HOME/bin/addC_template.sh

# # include ~/scripts directory
# PATH=$PATH:$HOME/scripts
