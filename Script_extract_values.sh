#!/bin/bash -l


refMNI=/usr/local/fsl/data/standard/MNI152_T1_1mm.nii.gz

#for each subject
for f in $(ls | grep P); do
	echo "${f}"
	cd ${f}
	mat=`pwd -P`/xfms/diff2standard.mat
	if [[ ! -e ${mat} ]]; then
		echo "  Cannot find mat file ${mat}"
		continue
	fi


	#for each tract
	for t in $(ls | grep "tractography"); do
		if [[ ! -d ${t} ]]; then
			echo "  No directory ${f}/${t}"
			continue
		fi
		cd ${t}
		if [[ ! -e fdt_paths.nii.gz ]]; then
			echo "  Cannot find fdt_paths in ${f}/${t}"
			continue
		elif [[ ! -e waytotal ]]; then
			echo "  Cannot find waytotal in ${f}/${t}"
			continue
		fi

		
		fslmaths fdt_paths.nii.gz -div `cat waytotal` tract_norm.nii.gz
		flirt -ref /usr/local/fsl/data/standard/FMRIB58_FA_1mm.nii.gz -in dti_FA -omat my_affine_transf.mat
		fnirt --in=dti_FA.nii.gz --aff=my_affine_transf.mat --ref=/usr/local/fsl/data/standard/FMRIB58_FA_1mm.nii.gz --cout=my_nonlinear_transf.mat 
		applywarp --ref=/usr/local/fsl/data/standard/FMRIB58_FA_1mm.nii.gz  --in=dti_FA.nii.gz --warp=diff2standard.mat --out=fa2std.nii.gz 
		fslmaths tract_norm.nii.gz -thr 0.01 -bin tract_norm_thr01_mask.nii.gz
		fslmaths tract_norm_thr01_mask.nii.gz -mul fa2std.nii.gz fdt_paths_values.nii.gz
		#"${f}" >> results.txt
		fslstats fdt_paths_values -M -V >> results.txt
		cd ..
	done
	
	cd ..
	echo "  Done."
done
