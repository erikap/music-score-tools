#!/bin/bash

mkdir -p tmp
directory=`pwd`/*.pdf
for file in $directory
do
  file_name=${file##*/} # only keep part after last '/'
  echo $file_name
  pdfjam_options="--quiet -o tmp/${file_name} --paper a4paper ${file} '{},5,{}' ../frontpage.pdf '-' ${file} '2,3,4,1'"
  eval "pdfjam "${pdfjam_options}""
done
