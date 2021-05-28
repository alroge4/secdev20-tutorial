#!/usr/bin/env bash

#shell code script to run angr thru muse

#need to tell where to find virtualenv #####will have to FIX--make a file?
#virtualwrapper needs to be in .bashrc,
source 'virtualenvwrapper.sh'
#source '/code/tmp/angrDir/tmp/jsonfun/virtualenvwrapper.sh'

#ignoring first argument, setting up rest:
commit=$2
cmd=$3


#have to return 1
function version(){
	echo 1
}


#tool is always applicable
function applicable(){
	echo "true"
}

#take json from angr and give to how muse wants
function emit_results(){
	echo "$1" | \
	 jq --slurp
}

#get binary ready to call/run, get depends
function gettool(){
	
	#get virt env 
	#make a virt env to run angr
	mkvirtualenv --python=$(which python3) angrTemp > /dev/null 2>&1 && pip install angr > /dev/null 2>&1

	#above cmd does this auto
	#mkvirtualenv angrRun
	#test:list virt env????
	#lsvirtualenv

	#start that virt env-auto w/above cmd
	workon angrTemp
	
	#make a temp dir
	pushd /tmp >/dev/null

    ###change file name
	#need to get binary in git repo so pull raw version of file
	curl -LO https://raw.githubusercontent.com/alroge4/secdev20-tutorial/find/master/logerRunAngr.py > /dev/null 2>&1
	
	#make executable
	chmod a+x loggerRunAngr.py

	#leave tmp dir, go bk to where began
	popd >/dev/null
}


#how to have shell script run angr
#run angr
function run(){

	#echo '{ "helloooooo" : "you"}' | jq
	#actually get tool 
	gettool

    ####change file name
	#call angr, where it is download, and start at current dir if fail nada
	raw_resuts=$(python3 loggerRunAngr.py -f json -fail "" ./...)

	#call emit_results--set up json
	emit_results "$raw_results"
}	


if [[ "$cmd" = "run" ]] ; then
run
fi

if [[ "$cmd" = "applicable" ]] ; then
applicable
fi

if [[ "$cmd" = "version" ]] ; then
version
fi
