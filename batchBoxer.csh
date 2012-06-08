#! /bin/csh -f

foreach file (*$1.box)
  set b=$file:r
  batchboxer input=$b.mrc dbbox=$file scale=$2 output=$3
  endif
end


