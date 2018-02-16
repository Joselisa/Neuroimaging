#!/usr/bin/env bash

       
        #1.Linear registration of FA to T1_betted (output: diff2str.mat)
		flirt -ref ${T1_betted_image} -in ${FA_data} -omat ${diff2str} -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6 -cost corratio;

			#1.1.Invert matrices: diff2str to str2diff.mat
			convert_xfm -omat str2diff.mat -inverse diff2str.mat
				

		#2.Linear registration of T1_betted to standard space (MNI_2mm), (output: str2standard.mat)
		flirt -ref /usr/local/fsl/data/standard/MNI152_T1_2mm_brain -in ${T1_betted_image} -omat ${str2standard} -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12 -cost corratio

				#2.1. Invert matrices: str2standard to standard2str.mat
				convert_xfm -omat ${standard2str} -inverse ${str2standard}

		#3. Combining matrices to create diff2standard.mat
				#convert_xfm -omat ${diff2standard} -concat ${str2standard} ${diff2str}

				#Invertendo o diff2str pra criar o diff2FMRIB.mat
				#convert_xfm -omat ${FMRIB2diff} -inverse ${diff2FMRIB}



        # Apply calculated warp from DWI to MNI, output: warpedFAFile2MNI.nii 


		fnirt --in=${T1_image} --aff=str2standard.mat --cout=str2standard_warp --config=T1_2_MNI152_2mm 

		fnirt --in=${FA_data} --aff=str2standard.mat --cout=str2standard_warp --config=T1_2_MNI152_2mm 

		applywarp --ref=${FSLDIR}/data/standard/MNI152_T1_2mm --in=${FA_data} --warp=str2standard_warp --premat=diff2struct.mat --out={warpedFAFile2MNI};

        applywarp --ref=${FSLDIR}/data/standard/MNI152_T1_2mm_brain --in=${FA_data} --warp=${diff2str} --out=${warpedFAFile2MNI};
        echo "applywarp ok for $FA_data"
        echo "created ${warpedFAFile2MNI}"


		for roiFile in *_ROI.nii
		    do
		    echo Roi File is "${roiFile}";
		    fslstats ${warpedFAFile2MNI} -k $roiFile -M -S >> ${FA_data}_${roiFile}.txt
		done

		echo fslstats ok!;

		echo Done!; 
	done




 