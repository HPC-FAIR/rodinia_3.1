import re
import os,sys
import pandas as pd
import numpy as np

def convert(argv):
        #print(argv[0])
	DIR=argv[0]
	outputfile = os.path.join(DIR,'vtuneLog.csv')
	backupoutputfile = os.path.join(DIR,'vtuneLog.csv.bk')
	if(os.path.exists(outputfile)):
 		os.rename(outputfile, backupoutputfile)
	files = [f for f in os.listdir(DIR) if os.path.isfile(os.path.join(DIR, f))]
	for f in files:
		fullpath = os.path.join(DIR, f)	
		print("processing C:" + fullpath)
		getInfo(fullpath, outputfile)

def getInfo(inputfile, outputfile):
	filename = os.path.basename(inputfile)
	filenamenoext = filename.rsplit('.')[0]
	filecomp = re.split(r'_',filenamenoext)
	filecomp[1:len(filecomp)-1] = [''.join(filecomp[1:len(filecomp)-1]) ]
	threadcount = filecomp[0]
	inputinfo = filecomp[1]
	vtuneCategory = filecomp[-1]
#	print(threadcount,vtuneCategory)
#	print(filecomp)
	file = open(inputfile,"r",encoding="utf-8")
	Lines = file.readlines()
	df = pd.DataFrame(columns = ['vtuneCategory','threadcount','inputinfo','metric', 'value'])
	for l in Lines:
		#print(l)
		l = l.rstrip()
		dat = re.split(r'\t+', l)
		del dat[0]
		dat = [vtuneCategory,threadcount,inputinfo] + dat
		if(len(dat) == 5):
#			print(dat[3])
			df.loc[len(df.index)] = dat
#	print(df)
	df.to_csv(outputfile, index=False, mode = 'a')
		

if __name__ == "__main__":
        convert(sys.argv[1:])

