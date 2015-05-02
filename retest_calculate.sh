#!/bin/sh

for dir in *; do
	for file in $dir/Labels/most_recent_labels.mnc $dir/Retest/most_recent_labels.mnc; do
		resampled=$(dirname $file)/labels_June.27_resampled_T1.mnc
		if [ ! -e $resampled ] ; then
			mincresample -near -like $dir/$(basename $dir)_T1.mnc $file $resampled
			minclookup -discrete -lut_string "1 1;2 1;4 1;5 1;6 1;101 101;102 101;104 101;105 101;106 101" $(dirname $file)/labels_June.27_resampled_T1.mnc $(dirname $file)/labels_June.27_whole_resampled_T1.mnc
		fi
	done
	echo $dir >> ../retest_values.csv
	volume_similarity --csv $dir/Labels/labels_June.27_resampled_T1.mnc $dir/Retest/labels_June.27_resampled_T1.mnc | grep '1\|2\|4\|5\|6\|101\|102\|104\|105\|106' | grep -v '0,0' | cut -f1,2 -d ',' >> ../retest_values.csv
	echo ${dir}_whole >> ../retest_values.csv
	volume_similarity --csv $dir/Labels/labels_June.27_whole_resampled_T1.mnc $dir/Retest/labels_June.27_whole_resampled_T1.mnc | grep '1\|101' | grep -v '0,0' | cut -f1,2 -d ',' >> ../retest_values.csv
done
