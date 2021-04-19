
####
###        these commands can be added to vul_Dis....
#####

#script that will run the angr tool
#this script sets up edirection of angr output to a file that will be then 
#translated to json and fed to muse


##!!!may do virtual env here to
import subprocess

import json


output_file = open('redirJson.txt', 'w')
json_file = open('angr_muse.json', 'a')

#run the angr vulnerability tool on a file and redirect output to a file
subprocess.run(["python", "vulDis_angr2_trial.py", "CADET_00001"],
                 stdout=output_file, stderr=output_file)

output_file.close()

#will print to screen
#print("done...now to read from file")

#set up to convert to json
for line in open('redirJson.txt', 'r'):
    print jsonStr = json.dumps(line)

    #do we need a file or can we just spit out json?
    #write to json file
    #json_file.writelines(line)

json_file.close()


'''
#print/as results to muse program
for line in open('angr_muse.json', 'r'):
    print(line)
'''

#print("json should be ready")

