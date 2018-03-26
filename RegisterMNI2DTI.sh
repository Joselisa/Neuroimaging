#!/usr/bin/env bash

# This script registers a ROI file (in std space) to the native space (diffusion).
# Requirements: DWI file, lesion mask (same DWI file name as a prefix) and you ROI (filename ROI)
for originalFile in *[^_lesion_mask][^_ROI].nii;
    do
         echo Running "$originalFile"... ;
        
        # Defining file names...
        afflineFile=${originalFile%.nii}_affline_transf.mat;
        lesionMaskFile=${originalFile%.nii}_lesion_mask;
        warpedFAFile2MNI=${originalFile%.nii}_my_warped_fa;
        roiFile=ROI;
        nonlinear_transf=${originalFile%.nii}_my_nonlinear_transf;
        MNI2DTI=${originalFile%.nii}_MNI2DTI;
        roi_DTIspace=${originalFile%.nii}_ROI_DTI_space.nii;

        # Running commands...
        flirt -ref ${FSLDIR}/data/standard/FMRIB58_FA_1mm -in ${originalFile} -omat ${afflineFile};
        echo Flirt ok!

        fnirt --in=${originalFile} --aff=${afflineFile} --cout=${nonlinear_transf} --inmask=${lesionMaskFile} --config=FA_2_FMRIB58_1mm.cnf;
        echo Fnirt ok!

        applywarp --ref=${FSLDIR}/data/standard/FMRIB58_FA_1mm --in=${originalFile} --warp=${nonlinear_transf} --out=${warpedFAFile2MNI};
        echo Applywarp ok DTI2MNI!

        invwarp --ref=${originalFile} --warp=${nonlinear_transf} --out=${MNI2DTI};
        echo Invwarp ok!

        applywarp --ref=${originalFile} --in=${roiFile} --warp=${MNI2DTI} --out=${roi_DTIspace} --interp=nn;
        echo Applywarp MNI2DTI ok!

        fslstats ${MNI2DTI}.nii.gz -k ${roi_DTIspace} -M -S >> ${originalFile}_${roiFile}.txt;
        echo fslstats ok!;
done
