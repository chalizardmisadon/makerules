#!/bin/bash

# script name
bashFile=$(basename ${BASH_SOURCE[0]})

# basic UI color
clrRst="\e[0m"			# Reset
clrRed="\e[91m"			# Red
clrGrn="\e[92m"			# Green
clrSpr="\e[38;5;45m"	# Spring
clrSky="\e[38;5;45m"	# Sky
clrAvo="\e[38;5;106m"	# Avocado
clrCop="\e[33m"			# Copper
clrLat="\e[93m"			# Latte
clrOrg="\e[38;5;214m"	# Orange
clrSal="\e[38;5;216m"	# Salmon
clrGdr="\e[38;5;220m"	# Goldenrod
clrRyl="\e[38;5;221m"	# Royal
clrPch="\e[38;5;222m"	# Peach
clrBlu="\e[94m"			# Blue
clrMgt="\e[38;5;206m"	# Magenta	

clrBlk="\e[30m"			# Black
bgrGry="\e[47m"			# Grey
bgrGrn="\e[48;5;82m"	# BG Green

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
	echo -e "  "$clrGrn-c$clrRst"       for C"
	echo -e "  "$clrSky-cpp$clrRst"     for C++"
	echo -e "  "$clrGdr-py[2\|3]$clrRst" for Python [2|3]"
	echo -e "  "$clrMgt-jl$clrRst"      for Julia"
	
	usage="usage: $(basename ${BASH_SOURCE[0]})"
	usgLn=$(seq ${#usage})
	usgSp=$(printf " %.0s" $usgLn)
	echo "$usage [-(template)[=folderName]]"
	echo "$usgSp [-s <symbolic link path>]"
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
	c | cpp | py | jl)

		# check =folderName
		if [[ $tempDst == "" ]]; then
			tempDst=$tempDir				#; echo $tempDst
		fi

		if [[ ! -d $tempSrc ]]; then
			echo -e Option $clrLat${arg%%=*}$clrRst\
					is missing template $clrRed$tempDir$clrRst!
			echo -e "$tabSpc"Please create template $clrBlu$tempSrc$clrRst
			exit 1
		elif [[ -d $PWD/$tempDst ]]; then
			echo -e Folder $clrRed$tempDst$clrRst already exist!
			exit 2
		else
			echo -e Creating folder $clrGrn$tempDst$clrRst\
					from template $clrLat$tempDir$clrRst ...
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
# 		echo -e No argument give. Default script directory is $clrLat$fileDir$clrRst"\r\n"
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
