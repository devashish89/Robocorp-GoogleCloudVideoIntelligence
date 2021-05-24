*** Settings ***
Documentation   Template robot main suite.
Library    RPA.Cloud.Google
Library    RPA.FileSystem
Library    parse_json.py
Library    String
Library    RPA.Tables
Library    Collections


*** Variables ***
&{dict_file_labels}
@{lst_filenames}
@{labels}

# +
*** Keywords ***
Init Client
    Init Video Intelligence Client  GoogleCloudVideoIntelligenceCredentials.json
    
Parse Video
    [Arguments]  ${file}  ${filename}
    ${result}=    Annotate Video  video_file=${file}  features=["LABEL_DETECTION"]  json_file=${CURDIR}${/}Output${/}${filename}.json
        
Create Folder
    [Arguments]  ${foldername}
    Create Directory  ${CURDIR}${/}${foldername}  exist_ok=True

Get Labels Of Video
    [Arguments]  ${jsonfile}  ${filename}
    LOG  ${filename}
    @{lst_labels}=    Get Labels Json  ${jsonfile}
    LOG  ${lst_labels}
    [Return]  @{lst_labels}

Get Files From Folder
    [Arguments]  ${foldername}
    @{files}=    List Files In Directory  ${CURDIR}${/}${foldername}
    FOR  ${file}  IN  @{files}
        LOG  ${file}
        ${filename}=    Get File Name  ${file}
        LOG  ${filename}
        
        ${filename_without_extension}=    Split String  ${filename}  .
        LOG  ${filename_without_extension}[0]
        
        Parse Video  ${file}  ${filename_without_extension}[0]
        Sleep  2
        @{lst_labels}=    Get Labels Of Video  ${CURDIR}${/}Output${/}${filename_without_extension}[0].json  ${filename}
        
        Set To Dictionary  ${dict_file_labels}  ${filename}=${lst_labels}
        Append To List  ${lst_filenames}  ${filename}
        Append To List  ${labels}  ${lst_labels}
        LOG  ${dict_file_labels}
        
    END



    

# -

*** Tasks ***
Task1
   Create Folder  Output
   Init Client
   Get Files From Folder  Videos
   LOG  ${dict_file_labels}
    &{dict1}=    Create Dictionary  filename=${lst_filenames}  labels=${labels}
    ${table}=    Create Table  data=${dict1}
    Write Table To Csv  ${table}  Output.csv
   
