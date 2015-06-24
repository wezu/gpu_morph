import os, sys

in_file=file(sys.argv[1], 'r')
out_file=file(sys.argv[2], 'w')

index=0

for line in in_file.readlines():
    if line.strip().startswith('<Normal>'):       
        out_file.write('        <AUX> index { '+str(index)+' 0 0 0 }\n')
        index+=1
    out_file.write(line)
