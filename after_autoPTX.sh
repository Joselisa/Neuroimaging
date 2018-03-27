#!/bin/bash -l

for subject in */ ;
	do
		echo Running Subject "$subject"....
	#Defining file names...
	affineFile=${subject}affine_transf.mat;
	nonlinearFile=${subject}my_nonlinear_transf.mat;
	ref_MNI=/usr/local/fsl/data/standard/FMRIB58_FA_1mm.nii.gz;
	fa2std=${subject}fa2std.nii.gz;
	dti_FA=${subject}dti_FA.nii.gz;
	echo "$dti_FA";
	#Register dti_FA to standard space - FMRIB58_FA_1mm
		flirt -ref $ref_MNI -in $dti_FA -omat $affineFile;
		fnirt --in=$dti_FA --aff=$affineFile --cout=$nonlinearFile --config=FA_2_FMRIB58_1mm.cnf;
		applywarp --ref=$ref_MNI --in=$dti_FA --warp=$nonlinearFile --out=$fa2std;
	done