#!/usr/bin/env bash

declare -a arr=(`cat ho.txt`)

# Intialize
datestamp=`date`
totaljobcount=0
fileroot="./archive"
summaryfile="$fileroot/summary.txt"
alljobs="$fileroot/alljobs.json"

# Ephemeral file creation
printf '' > $summaryfile

for i in "${arr[@]}"
do
    decodedname=`echo ${i//%26/&} | tr "[:upper:]" "[:lower:]"`
    limitcount=25
    startstring=""


    # Pull a single record to determine size of the result set
    jobcount=$(curl --silent --request GET  \
        "https://indeed-indeed.p.mashape.com/apisearch?publisher=127676247689188&format=json&l=&v=2&limit=1&q=company:\"$i\"" \
          -H 'Accept: application/json' \
          -H 'Cache-Control: no-cache' \
          -H 'Postman-Token: bc9953ce-f706-08a3-bbf2-be05956fa3d2' \
          -H 'X-Mashape-Key: YjtQBqSWKmmshwn5c06JmE2Ut5VSp1X5Z25jsn9laldG042Uoy' \
        | grep totalResults | jq -r '.totalResults')

    totaljobcount=$(($totaljobcount + $jobcount));
    printf "$decodedname -- $jobcount\n" >> "$summaryfile"


    # Report back whether jobs were found or not
    if [ "$jobcount" -eq "0" ]
    then
        printf "\n\nPrepping $decodedname... hmmmm, no jobs found... <sigh>\n"
        printf "Suspended download.\n"
    else
        printf "\n\nPrepping $decodedname...\t $jobcount job(s) found!\n"
        printf '' > "$fileroot/$decodedname.json"
        printf "Retrieving job(s)...\n"
    fi


    # Determine if resultset will exceed Indeed imposed resultset size,
    #   if so, set number of API call iterations required
    if [ "$jobcount" -lt "$limitcount" ]
    then
        limitcount=$jobcount
    else
        startstring="&start=[0-$jobcount:$limitcount]"
    fi


    # Retrieve records -- curl will use "start" and "limit" to iterate as appropriate
    curl -# --request GET \
     "https://indeed-indeed.p.mashape.com/apisearch?publisher=127676247689188&format=json&l=&v=2$startstring&limit=$limitcount&q=company:\"$i\"" \
          -H 'Accept: application/json' \
          -H 'Cache-Control: no-cache' \
          -H 'Postman-Token: bc9953ce-f706-08a3-bbf2-be05956fa3d2' \
          -H 'X-Mashape-Key: YjtQBqSWKmmshwn5c06JmE2Ut5VSp1X5Z25jsn9laldG042Uoy' \
         | tee -a "$fileroot/$decodedname.json" "$alljobs.$datestamp"

    # Use something like the following to prettify json for readability if necessary
    #    cat $decodedname.json | python -m json.tool > $decodedname.json


    # Report back HO completion
    printf "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
    printf "$decodedname download complete\n"
    printf "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"

done

# Clean up and summary reporting
printf "  Job retrieval complete\n\n"
printf "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
printf "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
printf "  SUMMARY REPORT saved to file: $summaryfile.$datestamp\n"
printf "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
printf "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"

cat "$summaryfile"
mv "$summaryfile" "$summaryfile.$datestamp"
printf "Total jobs consumed on $datestamp: <drum roll>... $totaljobcount"
