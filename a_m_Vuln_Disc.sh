#!/usr/bin/env bash

#shell code script to run angr thru muse

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
#function emit_results(){}

#get binary ready to call/run, get depends
function gettool(){
	
	#make a virt env to run angr
	sudo apt-get install python3-dev libffi-dev build-essential virtualenvwrapper
	
	#make a temp dir
	pushd /tmp >/dev/null

    ###change file name
	#need to get binary in git repo so pull raw version of file
	curl -LO https://raw.githubusercontent.com/alroge4/secdev20-tutorial/find/master/angr_muse_rap.py
	
	#make executable
	#chmod a+x vulDis_angr1.py

	#leave tmp dir, go bk to where began
	popd >/dev/null

}


#how to have shell script run angr
#run angr
function run(){
	#actually get tool 
	gettool

    ####change file name
	#call angr, where it is download, and start at current dir if fail nada
	raw_resuts=$(/tmp/angr_muse_rap.py -f json -fail "" ./...)
	
	#call emit_results--set up json
	#emit_results "$raw_results"
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
