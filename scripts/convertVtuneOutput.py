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

	df = pd.DataFrame(columns = ['vtuneCategory','threadcount','inputinfo','metric', 'value'])

	for f in files:
		if f.endswith(".log"):
			fullpath = os.path.join(DIR, f)	
			print("processing:" + fullpath)
			getInfo(fullpath, df)


	metrics = df[['metric']].copy()
	metrics.drop_duplicates( inplace=True)
	metricslist = metrics["metric"].tolist()
	metricslist.pop(0)
	#print(metricslist)
	newdf = pd.DataFrame (columns = ['threadcount','inputinfo'])
	for col in metricslist:
		newdf[col] = 0

	for index, row in df.iterrows():
		#print(row['vtuneCategory'], row['threadcount'])
		new_row ={'threadcount':row['threadcount'],'inputinfo':row['inputinfo']}
		newdf = newdf.append(new_row, ignore_index=True)

	newdf = newdf.drop_duplicates()
	for index, row in df.iterrows():
		newdf.loc[(newdf['threadcount'] == row['threadcount'] ) & (newdf['inputinfo'] == row['inputinfo']), row['metric']] = row['value']

	print(newdf)
	newdf.to_csv(outputfile, index=False, mode = 'a')


def getInfo(inputfile, df):
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
		

if __name__ == "__main__":
        convert(sys.argv[1:])

