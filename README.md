gen_vi
========

Generate Vegetation Index (VI) in GTiff Format from Landsat SR Stack  

genivi(imgFile,outFile,VI,redBand,nirBand,fmaskBand,maskValue,bluBand)  
batch_gen_vi(VI,path,pattern)  
gen_vi.sh VI path pattern

About
--------

The R script generates vegetation index (VI) such as NDVI (Normalized Difference Vegetation Index) and EVI (Enhanced Vegetation Index) layer based on Landsat surface reflectance data. The Landsat SR data need to be single stack in ENVI format including an additional cloud masking band. The output of the script is a single band raster in GeoTiff format. The resulting NDVI value is multiplied by 10000.

The batch function allows generating VI images for all existing Landsat images in a specific directory. The function searches the input directory and it's sub-directories for ENVI header file (.hdr) with a specific pattern ('*stack' by default). The newly created NDVI image will be named as the original image file appended with '_ndvi(/evi)', and it will be saved in the same directory as the original image.

Instruction
--------

**For single images, call gen_vi() with correct inputs.**

Input Arguments:   
- imgFile (String) - path and file name of the image file that the NDVI is generated from.  
- outFile (String) - path and file name of the output file (include extension .tif).  
- VI (String) - the vegetation index to calculate (support ndvi (default) and evi right now).  
- redBand (Integer) - sequence of the red band within the stack (default is 3 for Landsat).  
- nirBand (Integer) - sequence of the NIR band within the stack (default is 4 for Landsat).  
- fmaskBand (Integer) - sequence of the fmask band within the stack (default is 8).  
- maskValue (Vector, Integer) - a set of value to be masked in the fmask band (default is [255 2 3 4]).  
- bluBand (Integer) - sequence of the blue band within the stack for EVI calculation (default is 1 for Landsat).
   
Returns 0 indicates successful completion.

**For batch processing, call batch_gen_vi() with correct inputs.**

Input Arguments:
- VI (String) - the vegetation index to calculate (supports ndvi (default) and evi right now).  
- path (String) - path of where the program seek for Landsat images.  
- pattern (String) - pattern based on which the program searches for Landsat images (default is '*stack').  

Return 0 indicates successful completion.

**For sumbitting qsub jobs, use submit gen_vi.sh with correct inputs.**  

Input Arguments:
- VI (String) - the vegetation index to calculate (supports ndvi (default) and evi right now).  
- path (String) - path of where the program seek for Landsat images.  
- pattern (String) - pattern based on which the program searches for Landsat images (default is '*stack').  

Example
--------

    gen_vi('C:/LND1999123EDC00stack','C:/LND1999123EDC00.ndvi.tif','evi',3,4,8,c(255,2,3,4),1)  
    gen_vi('C:/LND1999123EDC00stack','C:/LND1999123EDC00.ndvi.tif','ndvi')

    batch_gen_vi('ndvi','C:/','*landsat')  
    batch_gen_vi('evi','C:/')  

    qsh gen_vi.sh 'ndvi' 'C:/' '*stack'  

Requirements:
--------

R (2.15.2 or higher)  
sp package (1.0-8 or higher)  
raster package (2.1-16 or higher)   
rgdal package (0.8-6 or higher)  

To run as a shell job:  
bash (4.1.2 or higher)  
RCurl Package (1.95-4.3 or higher)  


