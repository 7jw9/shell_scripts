#!/bin/bash

# Data pre-processing before performing a Principal Component Analysis (PCA)
# Input is directory with the name of the object type (ex. left_CA1) and containing that object file for all subjects. Must have all object files in this one directory. 
# Must also have the Master spreadsheet (named 'data', with the same number of subjects as is in dir) in the directory from where you are running this script
# Also need reference object

dir=$1
export object=$(basename $dir)

mkdir -p $dir/transformed
mkdir -p $dir/pcs
mkdir -p $dir/pcs_xyz
mkdir -p $dir/pcs_amp

# Dump the object points to a text file and change format of text file
if [ ! -e $dir/txts ]; then
	mkdir $dir/txts
	for file in $dir/objs/*.obj; do
		subject=$(basename $file .obj)
		dump_points_to_tag_file $file $dir/txts/${subject}.txt
	done
fi

for file in $dir/txts/*.txt; do
	cut -f2-4 -d' ' $file | tr '\n' ' ' > $dir/transformed/${subject}.txt
done

# Put reformatted text files for all subjects into same file
for file in $dir/transformed/*; do
	echo $(cat $file)
done > $dir/${object}.txt

# Clean up folders don't need anymore
# rm -r $dir/txts
# rm -r $dir/transformed

# Run pca in R. Output written to $dir/pcs
R --vanilla < pca.R

# Reformat pcs from R (from one column to three)
for file in $dir/pcs/*; do
	while read i; do
		read j
		read k
		echo $i $j $k
	done < $file > $dir/pcs_xyz/$(basename $file)
done

# Amplify pc shape change by 50 (to make the shape change easier to see). Output written to $dir/pcs_amp
R --vanilla < amplify_pcs.R

# Grab spatial information from reference object file (right now this is only good for the whole right/left hippocampus)


