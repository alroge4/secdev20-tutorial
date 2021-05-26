#!/usr/bin/env bash

#shell code script to run angr thru muse

#virtualwrapper needs to be in .bashrc,
#just in case put on git
source 'virtualenvwrapper.sh'

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
	 jq --slurp '.[] | .file = .location.file | .line = .location.line | .type = .code | del(.location) | del(.severity) | del(.code) | del(.end) '
}

#get binary ready to call/run, get depends
function gettool(){
	
	#make a virt env to run angr
	mkvirtualenv --python=$(which python3) angrTemp > /dev/null 2>&1 && pip install angr > /dev/null 2>&1

	#start that virt env-auto w/above cmd
	workon angrTemp
	
	#make a temp dir
	pushd /tmp >/dev/null

    ###change file name
	#need to get binary in git repo so pull raw version of file
	curl -LO https://raw.githubusercontent.com/alroge4/secdev20-tutorial/find/master/logerRunAngr_MuseCsl.py > /dev/null 2>&1
	
	#make executable
	chmod a+x ~/tmp/angrDir/tmp/jsonfun/loggerRunAngr_MuseCsl.py

	#leave tmp dir, go bk to where began
	popd >/dev/null
}

#how to have shell script run angr
function run(){
 
	gettool

	#call angr, where it is download, and start at current dir if fail nada
	raw_resuts=$(python3 loggerRunAngr_MuseCsl.py -f json -fail "" ./...)

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
