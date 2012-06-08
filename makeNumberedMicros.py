#!/usr/bin/env python

import os
import shutil
import glob
import re


list = glob.glob("*en_00.mrc")

counter=1

for img in list:
	
	tmp1 = re.sub("_00_","_01_",img)
	tiltname = re.sub("_00.mrc","_01.mrc",tmp1) 
	boxImg = img.replace('.mrc','.box')
	boxTilt = tiltname.replace('.mrc','.box')
	
	if os.path.isfile(img) & os.path.isfile(tiltname) & os.path.isfile(boxImg) & os.path.isfile(boxTilt):
		print "%s  1  %s" %(counter,counter)	
		untilt="%03i_00.mrc" %(counter)
		tilt="%03i_01.mrc" %(counter)
		newBoxImg="%03i_00.box" %(counter)
		newBoxTilt="%03i_01.box" %(counter)
		
		os.symlink(img,untilt)	
		
		os.symlink(tiltname,tilt)
		
		os.symlink(boxImg,newBoxImg)
		
		os.symlink(boxTilt,newBoxTilt)
		
		counter=counter+1
	
