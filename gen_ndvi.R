# gen_ndvi.R
# Version 1.1
# Main Function
#
# Project: Landsat Proessing
# By Xiaojing Tang
# Created On: Unknown
# Last Update: 9/12/2014
#
# Input Arguments: 
#   See specific function.
# 
# Output Arguments: 
#   See specific function.
#
# Usage: 
#   1.Intstall sp, raster, and rgdal before using this script.
#   2.Remove the .aux.xml file and keep the .hdr file only before running this script
#   3.Read the specific manual for the functio that you are trying to use
#   4.Run either function individually or call them with other script
#
# Version 1.0 - 8/27/2013
#   This script generates NDVI based on preprocessed Landsat image stack
#   gen_ndvi generates NDVI for one specific image given the full path to the image
#   sid_gen_ndvi genarates NDVI for one specific image given the sceen id
#   Must set proper data path for sid_gen_ndvi before using it
#   The output is in GTiff format
#   Call either function by another script if you need to batch
#   NDVI is in integer format multiplied by 10000
#
# Update of Version 1.1 - 9/12/2014
#   1.Updated comments
#
#----------------------------------------------------------------

# Libraries and sourcing
library(sp)
library(raster)
# library(rgdal)

#--------------------------------------

# gen_ndvi
# Generate NDVI layer based on a specific image stack
#
# Input Arguments: 
#   imgFile (String) - path and file name of the image file that the NDVI is generated from
#   outFile (String) - path and file name of the output file (include extension .tif)
#   redBand (Integer) - sequence of the red band within the stack (default is 3 for Landsat)
#   nirBand (Integer) - sequence of the NIR band within the stack (default is 4 for Landsat)
#   fmaskBand (Integer) - sequence of the fmask band within the stack (default is 8)
#   maskValue (Vector, Integer) - a set of value that is considere to be masked in the fmask band
#
# Output Arguments: 
#   r (Integer) - 0: Successful
#
# Usage: 
#   1.Run the function with correct input arguments.
#
gen_ndvi <- function(imgFile,outFile,redBand=3,nirBand=4,fmaskBand=8,maskValue=c(255,2,3,4)){
  # read in image
  fmaskImg <- raster(imgFile,band=fmaskBand)
  redImg <- raster(imgFile,band=redBand)
  nirImg <- raster(imgFile,band=nirBand)
  samples <- ncol(fmaskImg)
  lines <- nrow(fmaskImg)
  
  # convert to matrix
  fmask <- raster::as.matrix(raster(imgFile,band=fmaskBand))
  nir <- raster::as.matrix(raster(imgFile,band=nirBand))
  red <- raster::as.matrix(raster(imgFile,band=redBand))
    
  # generate ndvi matrix
  ndviMtx <- matrix(-9999,lines,samples)
  pct <- 0
  for(i in 1:lines){
    for(j in 1:samples){
      if(!max(fmask[i,j]==maskValue)){
        ndviMtx[i,j]<-round(((nir[i,j]-red[i,j])/(nir[i,j]+red[i,j]))*10000)
      }
    }
    
    if((floor(i/lines*100)-pct)>=5){
      pct <- floor(i/lines*100)
      cat(paste(pct,'%\n',sep=''))
    }
  }
  
  # generate ndvi raster
  ndviRas <- raster(ndviMtx) 
  extent(ndviRas) <- extent(fmaskImg)
  projection(ndviRas) <- projection(fmaskImg)
  NAvalue(ndviRas) <- -9999
  res(ndviRas) <- c(30,30)

  # write output  
  writeRaster(ndviRas,filename=outFile,format='GTiff',NAflag=-1,overwrite=T)
  rm(fmask)
  rm(nir)
  rm(red)
  rm(ndviMtx)
  rm(ndviRas)
  
  # done
  return(0)
}
