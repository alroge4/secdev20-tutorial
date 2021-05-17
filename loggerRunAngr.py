##working redirection: runAngrCmd &> file.txt

import sys
import logging
from logging import StreamHandler
import angr
import os
import logging.config
import json

#get rid of their handlers---will is stil log??
root = logging.getLogger()
if root.handlers:
	for handler in root.handlers:
		root.removeHandler(handler)

mylogs = logging.getLogger()
#mylogs = logging.getLogger(__name__)

mylogs.setLevel(logging.WARNING)
handler = logging.StreamHandler()
#handler = logging.FileHandler('msglog.log')
handler.setLevel(logging.WARNING) 
#std formatter
#formatter = logging.Formatter('%(levelname)-7s | %(asctime)-23s | %(name)-8s | %(message)s')
#tring json formaterr

#formatter = logging.Formatter('{"level": "%(levelname)s", "time": "%(asctime)s", "name": "%(name)s" , "message": "%(message)s"}')
formatter = logging.Formatter('{"file": "%(levelname)s", "line": "%(asctime)s", "type": "%(name)s" , "message": "%(message)s"}')

handler.setFormatter(formatter)
mylogs.addHandler(handler)
 
#_______PPRINT STATEMENTS_________________________________
#samples to print (these on screen print like angr's w/'|')
mylogs.warning("this is a warning")
mylogs.error("this is an error")
mylogs.critical("this is critical")
mylogs.debug("debug")   #should not print
mylogs.info("info2")    #should not print


#______JSON WORK________________________________________
#msg: Level | timestmp | name/logger | prob/msg
#every print out should be run thru here then returned
#---REAL TIME
#there is a module: from pythonjsonlogger import json logger
#pip install python-json-logger
#then change formatter = jsonlogger.JsonFormatter()
#file then out
#change at file level, no extra installs

#____OR, dont have to convert to json just format as json:
#json_format = logging.Formatter('{"time": "%(acstime)s", "level": "%(levelname)s", "message": "%(message)s"}')
#may not need to go to file because, sh will convert what results it gets
'''
class Messages:
    def __init__(self, level, timestamp, currentLgr, message):
        self.level = level
        self.timestamp = timestamp
        self.currentLgr = currentLgr
        self.message = message
'''
#try an angr run
#def main(argv): 
def main():
    #path_to_binary = argv[1]
    #project= angr.Project(path_to_binary)
    project= angr.Project("./CADET_00001")
    #print("finding the buffer overflow...")

    sm = project.factory.simulation_manager(save_unconstrained=True)

    #symbolically execute the binary until an unconstrained path is reached
    while len(sm.unconstrained)==0:
        sm.step()
    unconstrained_state = sm.unconstrained[0]
    crashing_input = unconstrained_state.posix.dumps(0)
    #cat crash_input.bin | ./CADET_00001.adapted will segfault
    with open('crash_input.bin', 'wb') as fp:
        fp.write(crashing_input)
    #print("buffer overflow found!")
    #print(repr(crashing_input))


if __name__ == '__main__':
    #throws error may not need for argv as file
    #main(sys.argv)
    #print(repr(main()))
    main()