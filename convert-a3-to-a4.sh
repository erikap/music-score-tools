#!/bin/bash

###
# Script splitting A3 pages in a PDF file to A4 using pdfposter
#
###
directory=`pwd`/*.pdf
for file in $directory
do
  file_name=${file##*/} # only keep part after last '/'
  file_name_no_ext=${file_name%.*} # remove everything after last '.' (= file extension)
  pdfposter -s1 $file $file_name_no_ext-a4.pdf
done
