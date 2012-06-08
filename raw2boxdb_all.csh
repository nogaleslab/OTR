#!/bin/csh -f

# This is accompanied by raw2boxdb2.pl NOT spi2boxdb.pl

#This will transfer xmipp output coordinates from .raw to a .box file, allowing you to generate a stack using the batchboxer EMAN command.

# Extension of the signature spider particle file.  This will be removed and replaced with .box.
# I recommend taking off any extension(s) that may be on the file name, so that when the .box file # is generated, it will correspond exactly to the original leginon micrograph name.  This will let # you import the .box files into appion or simply use batchboxer for extracting particles.

# INPUTS

# Extension of the file to be removed
set ext=.raw.Common.pos

#Image size of micrograph
set imageSize=1024

# Set boxsize for images that were picked
set boxsize=100

# Loops over each file within a given folder that has the input extension
foreach file (*$ext)

#set base=`echo basename "$file"`

set filename=`echo $file | sed 's/down4_//' | sed -e 's/'$ext'//'`

echo $file
echo $filename

raw2boxdb2.pl -b $boxsize -i $file -o $filename.box -d -s $imageSize 

end
