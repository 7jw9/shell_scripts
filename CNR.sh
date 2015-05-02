#!/bin/sh

#Calculate contrast-to-noise ratio

(
  echo Subject space GM_Mean space GM_Var space WM_Mean space WM_Var CNR
  i=1
  y=1
for file in */CNR/masks_T1.mnc; do
  name=$(dirname $(dirname $file))
  mask_resampled=$name/CNR/$(basename $file .mnc)_resampled_T1.mnc
  if [ ! -e $mask_resampled ]; then
     mincresample -near -like $name/${name}_T1.mnc $file $mask_resampled
  fi
  echo $i $(mincstats -mean -variance $name/${name}_T1.mnc -mask $mask_resampled -mask_binvalue 1  | tr '\n' ' ') $(mincstats -mean -variance $name/${name}_T1.mnc -mask $mask_resampled -mask_binvalue 2 | tr '\n' ' ')
  i=$(($i+$y))
done 
) | cut -f1,3,5,7,9,10 -d ' ' > ../CNR_values_T1.csv
