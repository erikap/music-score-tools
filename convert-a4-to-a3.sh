#!/bin/bash

###
# Script converting A4 pages in a PDF file to A3 using pdfjam
#
# Options:
# - to add  a blank page at the start (in case of odd number of pages): --openright true
#
# All pdfjam options are documented in https://mirror.lyrahosting.com/CTAN/macros/latex/contrib/pdfpages/pdfpages.pdf
###

directory=`pwd`/**/*.pdf
for file in $directory
do
  pages=`pdfinfo $file | awk '/^Pages:/ {print $2}'`
  pdfjam_options="--suffix a3 --paper a3paper --landscape --nup '2x1'"
  if [ $(($pages%2)) -eq 0 ]
  then
    # even number of pages
    pdfjam_options=$pdfjam_options
  else
    # odd number of pages
    pdfjam_options="$pdfjam_options --openright true"
  fi

  eval "pdfjam "${pdfjam_options} ${file}""
done

#find `pwd` -type f -name "*.pdf" -print0 | xargs -0 -I {} echo "Processing {}"
