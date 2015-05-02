#! /bin/bash

for file in Subjects/*/Correct_Registration/correct_average_2.mnc; do
	 /projects/old_home/mallar/bin/sge_batch -q high.q mincANTS 3 -m PR[$file,/projects/julie/Hippocampus/correct_average_model_2.mnc,1,4] \
   	 --use-Histogram-Matching \
	 --continue-affine false \
   	 --MI-option 32x16000 \
	 -r Gauss[3,0] \
   	 -t SyN[0.5] \
	 -o $(dirname $file)/nl_3.xfm \
	 -i 100x100x100x50
done

for file in Subjects/*/Correct_Registration/nl_3.xfm; do
	/projects/old_home/mallar/bin/sge_batch -q high.q mincresample -tricubic -like /projects/julie/Hippocampus/correct_average_model_2.mnc -transformation $file $(dirname $file)/correct_average_2.mnc $(dirname $file)/correct_average_3.mnc
done

mincaverage Subjects/*/Correct_Registration/correct_average_2.mnc correct_average_model_2.mnc

for file in Subjects/*/Registration/v7_average_1.mnc; do
         /projects/old_home/mallar/bin/sge_batch -q high.q mincANTS 3 -m PR[/projects/julie/Hippocampus/v7_average_model_1.mnc,$file,1,4] \
         --use-Histogram-Matching \
         --continue-affine false \
         --MI-option 32x16000 \
         -r Gauss[5,1] \
         -t SyN[0.4] \
         -o $(dirname $file)/v7_nl_2_v3.xfm \
         -i 0x100x0
done

for file in Subjects/*/Registration/nl_2.xfm; do
	mincresample -tricubic -like /projects/julie/Hippocampus/average_model_1.mnc -transformation $file $(dirname $file)/average_1.mnc $(dirname $file)/average_2.mnc
done

mincaverage Subjects/*/Registration/average_2.mnc average_model_2.mnc

for file in Subjects/*/Registration/average_2.mnc; do
         mincANTS 3 -m PR[/projects/julie/Hippocampus/average_model_2.mnc,$file,1,4] \
         --use-Histogram-Matching \
         --continue-affine false \
         --MI-option 32x16000 \
         -r Gauss[3,0] \
         -t SyN[0.5] \
         -o $(dirname $file)/nl_3.xfm \
         -i 0x5x10
done

for file in Subjects/*/Registration/nl_3.xfm; do
        mincresample -tricubic -like /projects/julie/Hippocampus/average_model_2.mnc -transformation $file $(dirname $file)/average_2.mnc $(dirname $file)/average_3.mnc
done

mincaverage Subjects/*/Registration/average_3.mnc average_model_final.mnc

# 1st try
	# 1st: mincANTS 3 -m PR[/projects/julie/Hippocampus/average_model.mnc,$file,1,4]          
	# --use-Histogram-Matching          
	# --continue-affine false          
	# --MI-option 32x16000          
	# -r Gauss[3,0]          
	# -t SyN[0.5]          
	# -o $(dirname $file)/nl_1.xfm          
	# -i 100x20x5x0
	# 2nd: -i 50x10x2
	# 3rd: -i 5x20x10
# 2nd try
	# same as above, but
	# 1st: 100x20x5
# 3rd try (MAGeT paper params)
	# 1st: 100x100x100x0
	#	-r Gauss[5,1]
	#	-t SyN[0.4]
# 4th try 
	# include linear registration
	# /projects/old_home/mallar/bin/sge_batch -q high.q mincANTS 3 -m PR[/projects/julie/Hippocampus/average_model.mnc,$file,1,4] \
        # --use-Histogram-Matching \
        # --number-of-affine-iterations 10000x10000x10000x10000x10000 \
        # --MI-option 32x16000 \
        # --affine-gradient-descent-option 0.5x0.95x1.e-4x1.e-4 \
        # -r Gauss[5,1] \
        # -t SyN[0.4] \
        # -o $(dirname $file)/v4_nl_1.xfm \
        # -i 100x100x100x0
# 5th try
	# swap target and source
	#/projects/old_home/mallar/bin/sge_batch -q high.q mincANTS 3 -m PR[$file,/projects/julie/Hippocampus/average_model.mnc,1,4] \
        # --use-Histogram-Matching \
        # --continue-affine false \
        # --MI-option 32x16000 \
        # -r Gauss[5,1] \
        # -t SyN[0.4] \
        # -o $(dirname $file)/v5_nl_1.xfm \
        # -i 100x100x100x0
# 6th try
	# radius=3 instead of radius=4
	# for file in Subjects/*/Registration/average.mnc; do
        # /projects/old_home/mallar/bin/sge_batch -q high.q mincANTS 3 -m PR[/projects/julie/Hippocampus/average_model.mnc,$file,1,3] \
        # --use-Histogram-Matching \
        # --continue-affine false \
        # --MI-option 32x16000 \
        # -r Gauss[5,1] \
        # -t SyN[0.4] \
        # -o $(dirname $file)/v6_nl_1.xfm \
        # -i 100x100x100x0
# 7th try
	# 1st
	# just coarse registration
        #  /projects/old_home/mallar/bin/sge_batch -q high.q mincANTS 3 -m PR[/projects/julie/Hippocampus/average_model.mnc,$file,1,4] \
        # --use-Histogram-Matching \
        # --continue-affine false \
        # --MI-option 32x16000 \
        # -r Gauss[5,1] \
        # -t SyN[0.4] \
        # -o $(dirname $file)/v7_nl_1.xfm \
        # -i 100x0x0

	# 2nd
	# some coarse, some medium
	# for file in Subjects/*/Registration/v7_average_1.mnc; do
	#  /projects/old_home/mallar/bin/sge_batch -q high.q mincANTS 3 -m PR[/projects/julie/Hippocampus/v7_average_model_1.mnc,$file,1,4] \
        # --use-Histogram-Matching \
        # --continue-affine false \
        # --MI-option 32x16000 \
        # -r Gauss[5,1] \
        # -t SyN[0.4] \
        # -o $(dirname $file)/v7_nl_2.xfm \
        # -i 20x50x0
	# done
	# v2 -i 20x0x0
	# v3 -i 2x100x0
# 8th try
	# only finer registrations
	#  /projects/old_home/mallar/bin/sge_batch -q high.q mincANTS 3 -m PR[/projects/julie/Hippocampus/average_model.mnc,$file,1,4] \
        # --use-Histogram-Matching \
        # --continue-affine false \
        # --MI-option 32x16000 \
        # -r Gauss[5,1] \
        # -t SyN[0.4] \
        # -o $(dirname $file)/v8_nl_1.xfm \
        # -i 0x10x5
# 9th try
	# only coarsest level of registration
	#  /projects/old_home/mallar/bin/sge_batch -q high.q mincANTS 3 -m PR[/projects/julie/Hippocampus/average_model.mnc,$file,1,4] \
        # --use-Histogram-Matching \
        # --continue-affine false \
        # --MI-option 32x16000 \
        # -r Gauss[5,1] \
        # -t SyN[0.4] \
        # -o $(dirname $file)/v9_nl_1.xfm \
        # -i 100x0x0x0
