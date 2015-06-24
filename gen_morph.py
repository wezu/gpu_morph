import os, sys
from panda3d.core import *
import json
#monkey-patch to make json file smaller
from json import encoder
encoder.FLOAT_REPR = lambda o: format(o, '.4f')

in_file1=file(sys.argv[1], 'r')
in_file2=file(sys.argv[2], 'r')

out_file_name=sys.argv[3]

vert_data=[]
morph_data=[]
read=False
i=-1

for line in in_file1.readlines():
    if line.strip().startswith('<Vertex>'): 
        read=True
    elif read:
        vert_data.append(map(float, line.split()))
        i=i+1
        read=False
i=0
for line in in_file2.readlines():
    if line.strip().startswith('<Vertex>'):
        read=True
    elif read:
        vert=map(float, line.split())          
        morph=[vert_data[i][0]-vert[0], vert_data[i][1]-vert[1], vert_data[i][2]-vert[2]] 
        morph_data.append(morph)        
        i=i+1
        read=False
        
with open(out_file_name, 'w') as outfile:
    json.dump(morph_data, outfile)



