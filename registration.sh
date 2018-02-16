#!/usr/bin/env bash

# Registration
echo 'Registering diffusion to standard space'

for subjdir in *;
 do
    echo Running "$subjdir"... ;
        
	mkdir -p ${subjdir}.bedpostX/xfms
	echo Created xfms folder "$subjdir"

	flirt -in /Users/INCE/Documents/Bedpostx/${subjdir}/nodif_brain -ref /usr/local/fsl/data/standard/FMRIB58_FA_1mm.nii.gz -omat /Users/INCE/Documents/Bedpostx/${subjdir}/xfms/diff2standard.mat -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12

	echo Flirt ok!;
	fnirt --in=/Users/INCE/Documents/Bedpostx/${subjdir}/nodif_brain --aff=/Users/INCE/Documents/Bedpostx/${subjdir}/xfms/diff2standard.mat --ref=/usr/local/fsl/data/standard/FMRIB58_FA_1mm.nii.gz --cout=diff2standard_warp
	echo FNIRT ok!;
	
	convert_xfm -omat /Users/INCE/Documents/Bedpostx/${subjdir}/xfms/standard2diff.mat -inverse /Users/INCE/Documents/Bedpostx/${subjdir}/xfms/diff2standard.mat
	echo diff2standard ok!;
	
	convert_xfm -omat /Users/INCE/Documents/Bedpostx/${subjdir}/xfms/standard2diff_warp -inverse /Users/INCE/Documents/Bedpostx/${subjdir}/xfms/diff2standard_warp
	echo diff2standard_warp ok!;

 done


