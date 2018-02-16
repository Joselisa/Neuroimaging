#!/bin/sh
#Substitue Seed and masks as you wish
SUJEITO=${1}
cd /Users/INCE/Documents/Bedpostx/${SUJEITO}.bedpostX
mkdir /Users/INCE/Documents/Bedpostx/${SUJEITO}.bedpostX/tractography_CST_L_M1
probtrackx2  -x /Users/INCE/Documents/CST_L_M1/HMAT_Left_M1.nii -V 1 -l --onewaycondition -c 0.2 -s 2000 --steplength=0.5 -P 5000 --fibthresh=0.01 --distthresh=0.0 --xfm=/Users/INCE/Documents/Bedpostx/${SUJEITO}.bedpostX/xfms/standard2diff_warp.nii.gz --invxfm=/Users/INCE/Documents/Bedpostx/${SUJEITO}.bedpostX/xfms/diff2standard_warp.nii.gz --avoid=/Users/INCE/Documents/CST_L_M1/mascara_exclusao_lado_R.nii --stop=/Users/INCE/Documents/CST_L_M1/cerebral_penducle_L.nii --forcedir --opd -s /Users/INCE/Documents/Bedpostx/${SUJEITO}.bedpostX/merged -m /Users/INCE/Documents/Bedpostx/${SUJEITO}.bedpostX/nodif_brain  --dir=/Users/INCE/Documents/Bedpostx/${SUJEITO}.bedpostX/tractography_CST_L_M1 --waypoints=/Users/INCE/Documents/CST_L_M1/waypoints.txt  --waycond=AND
mv /Users/INCE/Documents/Bedpostx/${SUJEITO}.bedpostX/tractography_CST_L_M1/fdt_log.tcl /Users/INCE/Documents/Bedpostx/${SUJEITO}.bedpostX/tractography_CST_L_M1/fdt.log
rm /Users/INCE/Documents/Bedpostx/${SUJEITO}.bedpostX/tractography_CST_L_M1/fdt_script.sh
