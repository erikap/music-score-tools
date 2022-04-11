#!/bin/bash

###
# Script creating a PDF file to print containing all parts, taking into account
# the configured number of copies for each part.
# The configuration must be put in ./print.txt in the same folder as the PDF files
# and contains a line per part "<file> <number_of_copies>" (eg. "flute-1st-in-C-a3.pdf 4")
#
# Options:
# - to add  a blank page at the start (in case of odd number of pages): --openright true
#
# All pdfjam options are documented in https://mirror.lyrahosting.com/CTAN/macros/latex/contrib/pdfpages/pdfpages.pdf
###

# Repeat a string pattern ($2) a number of times ($1) and write the output to $3
repeat() {
    # $1=number of patterns to repeat
    # $2=pattern
    # $3=output variable name
    printf -v "$3" '%*s' "$1"
    printf -v "$3" '%s' "${!3// /$2}"
}

output_file="_print-a4.pdf"
mkdir -p tmp

pdfjam_merge_options="--quiet -o ${output_file} --paper a4paper"
while IFS= read -r line; do
  if [ ! -z "$line" ]
  then
    entry=( $line )
    file=${entry[0]}
    file_name=${file##*/} # only keep part after last '/'
    file_name_no_ext=${file_name%.*} # remove everything after last '.' (= file extension)
    number=${entry[1]}

    # Normalize PDF file. I.e. ensure each file has an even number of pages
    # such that it can be printed recto verso.
    pages=`pdfinfo $file | awk '/^Pages:/ {print $2}'`
    pdfjam_options="--quiet -o tmp/${file_name} --paper a4paper"
    if [ $(($pages%2)) -eq 0 ]
    then
      # even number of pages
      pdfjam_options="$pdfjam_options ${file}"
    else
      # odd number of pages => add a blank page at the end
      pdfjam_options="${pdfjam_options} ${file} '-,{}'"
    fi
    eval "pdfjam "${pdfjam_options}""


    # Generate pdfjam command to concatenate all files
    # taking into account the configured number of copies for each file
    echo "${file_name}: ${number}"

    if [ "$number" -gt 0 ]
    then
      repeat $number '-,' pages_pattern
      pages_pattern=${pages_pattern%?} # trim last character
      pdfjam_merge_options="${pdfjam_merge_options} tmp/${file_name} '${pages_pattern}'"
    fi
  fi
done < print.txt

eval "pdfjam "${pdfjam_merge_options}""

echo "Merged PDF written to ${output_file}"
rm -r tmp
