#!/bin/bash -l

for subject in */ ;
	do
		echo Running Subject "$subject"...

	#Defining file names...
	nonlinearFile=my_nonlinear_transf.mat;
	fa2std=fa2std.nii.gz;
	dti_FA=dti_FA.nii.gz;


	cd $subject;
	

	for tract in $(cat /Users/INCE/Documents/Joselisa/autoPtx_backup/Normalizacao_tratos/list.txt);
	do
		echo Running "$tract"
			
		tract_MNI=${tract%.nii.gz}_MNI.nii.gz;
		
		tract_MNI_values=${tract%.nii.gz}_MNI_values.nii.gz;
		
		tract_native_values=${tract%.nii.gz}_native_values.nii.gz;

		#Register tract to MNI space
		applywarp --ref=$fa2std --in=$tract --warp=$nonlinearFile --out=$tract_MNI --interp=nn;
		
		#Extract metrics from both normalized tract and from native diffusion space
		fslmaths $tract_MNI -mul $fa2std $tract_MNI_values;
		fslmaths $tract -mul $dti_FA $tract_native_values;
	
		fslstats $tract_MNI_values -M -V >> ${subject%/}_results_MNI.txt;
		fslstats $tract_native_values -M -V >> ${subject%/}_native_results.txt;

	done
	cd -

done