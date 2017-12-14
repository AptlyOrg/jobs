#!/usr/bin/env bash

declare -a arr=("Commerce-Bank" "DST-Systems" "C2FO" "Kansas-City-Public-Library" "First-National-Bank-of-Omaha")

for i in "${arr[@]}"
do

    decodedname=`echo $i`
    limitcount=25
    startstring=""

    jobcount=$(curl --silent --request GET  \
        "https://indeed-indeed.p.mashape.com/apisearch?publisher=127676247689188&format=json&l=&v=2&limit=1&q=company:\"$i\"" \
          -H 'Accept: application/json' \
          -H 'Cache-Control: no-cache' \
          -H 'Postman-Token: bc9953ce-f706-08a3-bbf2-be05956fa3d2' \
          -H 'X-Mashape-Key: YjtQBqSWKmmshwn5c06JmE2Ut5VSp1X5Z25jsn9laldG042Uoy' \
        | grep totalResults | jq -r  '.totalResults')

    printf "\n\nPrepping $decodedname...\t $jobcount job(s) found!\n"
    printf '' > $decodedname.json
    printf "Retrieving job(s)...\n"


if [ "$jobcount" -lt "$limitcount" ]
then
    limitcount=$jobcount
else
    startstring="&start=[0-$jobcount:$limitcount]"
fi

    curl -# --request GET \
     "https://indeed-indeed.p.mashape.com/apisearch?publisher=127676247689188&format=json&l=&v=2$startstring&limit=$limitcount&q=company:\"$i\"" \
          -H 'Accept: application/json' \
          -H 'Cache-Control: no-cache' \
          -H 'Postman-Token: bc9953ce-f706-08a3-bbf2-be05956fa3d2' \
          -H 'X-Mashape-Key: YjtQBqSWKmmshwn5c06JmE2Ut5VSp1X5Z25jsn9laldG042Uoy' \
         >> $decodedname.json

    printf "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
    printf "$decodedname download complete\n"
    printf "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"

#    cat $decodedname.json | python -m json.tool > $decodedname.json
done

printf "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
printf "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
printf "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
printf "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
printf "Job retrieval complete."
