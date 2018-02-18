#!/usr/bin/env bash

for path in *.bedpostX
  do
    subject=${path%.bedpostX};
    cp ${subject}/nodif_brain.nii.gz ${path};
 done
