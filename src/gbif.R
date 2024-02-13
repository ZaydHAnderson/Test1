#gbif.r
#query species occurance data from gbif
#clean up the data
#save it to a csv file
#create a map to display species occurance points

#list of pakcages
packages<-c("tidyverse", "rgbif", "CoordinateCleaner", "leaflet", "mapview", "usethis")

#install packages not yet installed
installed_packages<-packages %in% rownames(installed.packages())
if(any(installed_packages==FALSE)){
  install.packages(packages[!installed_packages])
}

#Packages loading with library function
invisible(lapply(packages, library, character.only=TRUE))

usethis::edit_r_environ()

#not working !!!!
spiderBackbone<-name_backbone(name="Habronattus americanus")
speciesKey<-spiderBackbone$usageKey

occ_download(pred("taxonKey", speciesKey), format="SIMPLE_CSV")
# Username: zaydanderson
#E-mail: lc22-1091@lclark.edu
#Format: SIMPLE_CSV
#Download key: 0012239-240202131308920
#Created: 2024-02-13T20:27:19.228+00:00
#Citation Info:  
 # Please always cite the download DOI when using this data.
#https://www.gbif.org/citation-guidelines
#DOI: 10.15468/dl.vsc9pq
#Citation:
#GBIF Occurrence Download https://doi.org/10.15468/dl.vsc9pq Accessed from R via rgbif (https://github.com/ropensci/rgbif) on 2024-02-13


d <- occ_download_get('0012239-240202131308920', path="data/") %>%
  occ_download_import()

  write_csv(d, "data/rawData.csv")
  
  #cleaning
  fData<-d %>%
    filter(!is.na(decimalLatitude), !is.na(decimalLongitude))
  
  fData<-fData %>%
    filter(countryCode %in% c("US", "CA", "MX"))
  
  fData<-fData %>%
    filter(!basisOfRecord %in% c("FOSSIL_SPECIMEN", "LIVING_SPECIMEN"))
  
  fData<-fData %>%
    cc_sea(lon="decimalLongitude", lat = "decimalLatitude")