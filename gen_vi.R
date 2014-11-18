# gen_vi.R
# Version 2.0
# Main Function
#
# Project: Landsat Proessing
# By Xiaojing Tang
# Created On: Unknown
# Last Update: 11/18/2014
#
# Input Arguments: 
#   See specific function.
# 
# Output Arguments: 
#   See specific function.
#
# Usage: 
#   1.Intstall sp, raster, and rgdal before using this script.
#   2.Read the specific manual for the functio that you are trying to use
#   3.Run either function individually or call them with other script
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
# Update of Version 2.0 - 11/18/2014
#   1.Added EVI support
#   2.Automatically removes the .aux.xml file
# 
#----------------------------------------------------------------

# Libraries and sourcing
library(sp)
library(raster)
library(rgdal)
# library(rgdal)

#--------------------------------------

# gen_vi
# Generate VI layer based on a specific image stack
#
# Input Arguments: 
#   imgFile (String) - path and file name of the image file that the NDVI is generated from
#   outFile (String) - path and file name of the output file (include extension .tif)
#   VI (String) - VI to be calculated
#   redBand (Integer) - sequence of the red band within the stack (default is 3 for Landsat)
#   nirBand (Integer) - sequence of the NIR band within the stack (default is 4 for Landsat)
#   fmaskBand (Integer) - sequence of the fmask band within the stack (default is 8)
#   maskValue (Vector, Integer) - a set of value that is considere to be masked in the fmask band
#   bluBand (Integer) - sequence of the blue band within the stack
#
# Output Arguments: 
#   r (Integer) - 0: Successful
#
# Usage: 
#   1.Run the function with correct input arguments.
#
gen_vi <- function(imgFile,outFile,VI='ndvi',redBand=3,nirBand=4,fmaskBand=8,maskValue=c(255,2,3,4),bluBand=1){
  
  # remove .aux.xml file
  if(file.exists(paste(imgFile,'.aux.xml',sep=''))){
    file.remove(paste(imgFile,'.aux.xml',sep=''))
  }
  
  # read in image
  fmaskImg <- raster(imgFile,band=fmaskBand)
  # redImg <- raster(imgFile,band=redBand)
  # nirImg <- raster(imgFile,band=nirBand)
  samples <- ncol(fmaskImg)
  lines <- nrow(fmaskImg)
  
  # convert to matrix
  fmask <- raster::as.matrix(raster(imgFile,band=fmaskBand))
  nir <- raster::as.matrix(raster(imgFile,band=nirBand))
  red <- raster::as.matrix(raster(imgFile,band=redBand))
    
  # get blue band if calculating evi
  if(VI=='evi'){
    # bluImg <- raster(imgFile,band=bluBand)
    blu <- raster::as.matrix(raster(imgFile,band=bluBand))
  }
  
  # generate vi matrix
  viMtx <- matrix(-9999,lines,samples)
  pct <- 0
  for(i in 1:lines){
    for(j in 1:samples){
      if(!max(fmask[i,j]==maskValue)){
        if(VI=='evi'){
          viMtx[i,j]<-round((2.5*(nir[i,j]-red[i,j])/(nir[i,j]+6*red[i,j]-7.5*blu[i,j]+10000))*10000)
        }else{
          viMtx[i,j]<-round(((nir[i,j]-red[i,j])/(nir[i,j]+red[i,j]))*10000)
        }
        
      }
    }
    
    # print progress
    if((floor(i/lines*100)-pct)>=5){
      pct <- floor(i/lines*100)
      cat(paste(pct,'%\n',sep=''))
    }
  }
  
  # generate ndvi raster
  viRas <- raster(viMtx) 
  extent(viRas) <- extent(fmaskImg)
  projection(viRas) <- projection(fmaskImg)
  NAvalue(viRas) <- -9999
  res(viRas) <- c(30,30)

  # write output  
  writeRaster(viRas,filename=outFile,format='GTiff',NAflag=-1,overwrite=T)
  rm(fmask)
  rm(nir)
  rm(red)
  rm(viMtx)
  rm(viRas)
  gc()
  
  # done
  return(0)
}

batch_gen_vi <- function(VI='ndvi',path,pattern='*stack'){

  # check path
  if(!file.exists(path)){
    cat('Directory does not exist.\n')
    return(-1)
  }

  # refine path
  if(substr(path,nchar(path),nchar(path))=='/'){
    path <- substr(path,1,nchar(path)-1)
  }

  # find all files
  pattern <- paste(pattern,'*.hdr',sep='')
  fileList <- list.files(path=path,pattern=pattern,full.names=T,recursive=T)
  
  # loop through all files
  for(i in 1:length(fileList)){
    inFile <- substr(fileList[i],1,nchar(fileList[i])-4)
    outFile <- paste(inFile,'_',VI,'.tif',sep='')
    cat(paste('Processing',inFile,'\n'))
    gen_vi(inFile,outFile,VI)
  }

  # done
  return(0)
}
