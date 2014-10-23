gen_ndvi
========

Generate NDVI in GTiff Format from Landsat SR Stack

About
--------

The R script generates a NDVI (Normalized Difference Vegetation Index) layer based on Landsat surface reflectance data. The Landsat SR data need to be single stack in ENVI format including an additional cloud masking band. The output of the script is a single band raster in GeoTiff format. The resulting NDVI value is multiplied by 10000.

A batch version of this script is under development and will be online soon.

Instruction
--------

Call gen_ndvi() with correct inputs.

Input Arguments:   
- imgFile (String) - path and file name of the image file that the NDVI is generated from.  
- outFile (String) - path and file name of the output file (include extension .tif)  
- redBand (Integer) - sequence of the red band within the stack (default is 3 for Landsat)  
- nirBand (Integer) - sequence of the NIR band within the stack (default is 4 for Landsat)  
- fmaskBand (Integer) - sequence of the fmask band within the stack (default is 8)  
- maskValue (Vector, Integer) - a set of value to be masked in the fmask band (default is [255 2 3 4])
   
Returns 0 is successful.

Example
--------

gen_ndvi('C:/LND1999123EDC00stack','C:/LND1999123EDC00.ndvi.tif',3,4,8,c(255,2,3,4))  
gen_ndvi('C:/LND1999123EDC00stack','C:/LND1999123EDC00.ndvi.tif')

Requirements:
--------

R (2.15.2 or higher)  
sp package (1.0-8)  
raster package (2.1-16)  

