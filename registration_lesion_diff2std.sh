#!/usr/bin/env bash
 
for originalFile in *[^_lesion_mask].nii -o *[^_ROI].nii	
  do
    echo Running "$originalFile"... 
    
    # Defining file names...
    affineFile=${originalFile%.nii}_affine_transf;
    nonlinearFile=${originalFile%.nii}_my_nonlinear_transf;
    lesionMaskFile=${originalFile%.nii}_lesion_mask;
    warpedFaFile=${originalFile%.nii}_my_warped_fa;

    # Running commands...
    flirt -ref ${FSLDIR}/data/standard/FMRIB58_FA_1mm -in $originalFile -omat $affineFile;
    echo Flirt ok!;

    fnirt --in=$originalFile --aff=$affineFile --cout=$nonlinearFile --inmask=$lesionMaskFile --config=FA_2_FMRIB58_1mm.cnf;
    echo Fnirt ok!;

    applywarp --ref=${FSLDIR}/data/standard/FMRIB58_FA_1mm --in=$originalFile --warp=$nonlinearFile --out=$warpedFaFile;
    echo Applywarp ok!;

    for roiFile in *_ROI.nii
      do
        echo Roi File is "${roiFile}";
        fslstats ${warpedFaFile} -k $roiFile -M -S >> ${originalFile}_${roiFile}.txt
    done

    echo fslstats ok!;

    echo Done!;	

done
