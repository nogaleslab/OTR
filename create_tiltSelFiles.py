#!/usr/bin/env python

import glob
import re
import os

list=glob.glob("*00")

for img in list:
	
	tmp1 = re.sub("_00_","_01_",img)
	tiltname = re.sub("en_00","en_01",tmp1) 
	f1 = "./%s/down4_%s.raw" %(img,img)
	f2 = "./%s/down4_%s.raw" %(tiltname,tiltname)
	if os.path.isfile(f1) & os.path.isfile(f2):
		print "%s %s 1" %(f1,f2)	

