#!/usr/bin/env bash

declare -a arr=(`cat ho.txt`)

trendingfile="./target/trending.json"
printf '' > "$trendingfile"

for i in "${arr[@]}"
do

    decodedname=`echo ${i//%26/&} | tr "[:upper:]" "[:lower:]"`
    limitcount=25;
    startstring="";
    type='jt="parttime"&';         #Job type. Allowed values: "fulltime", "parttime", "contract", "internship", "temporary".
    jobcount=0;

    jobcount=$(curl --silent --request GET  \
   "https://indeed-indeed.p.mashape.com/apisearch?publisher=127676247689188&$typeformat=json&l=&v=2&limit=1&fromage=1&q=company:\"$i\"" \
          -H 'Accept: application/json' \
          -H 'Cache-Control: no-cache' \
          -H 'Postman-Token: bc9953ce-f706-08a3-bbf2-be05956fa3d2' \
          -H 'X-Mashape-Key: YjtQBqSWKmmshwn5c06JmE2Ut5VSp1X5Z25jsn9laldG042Uoy' \
        | grep totalResults | jq -r '.totalResults')

if [ "$jobcount" -eq "0" ]
then
    printf "\n\nPrepping $decodedname... hmmmm, no jobs found... <sigh>\n"
    printf "Suspended download.\n"
else
    printf "\n\nPrepping $decodedname...\t $jobcount job(s) found!\n"
    printf "Retrieving job(s)...\n"
fi

if [ "$jobcount" -lt "$limitcount" ]
then
    limitcount=$jobcount
else
    startstring="&start=[0-$jobcount:$limitcount]"
fi

    curl -# --request GET \
     "https://indeed-indeed.p.mashape.com/apisearch?publisher=127676247689188&$typeformat=json&l=&v=2$startstring&limit=$limitcount&q=company:\"$i\"" \
          -H 'Accept: application/json' \
          -H 'Cache-Control: no-cache' \
          -H 'Postman-Token: bc9953ce-f706-08a3-bbf2-be05956fa3d2' \
          -H 'X-Mashape-Key: YjtQBqSWKmmshwn5c06JmE2Ut5VSp1X5Z25jsn9laldG042Uoy' \
         >> "$trendingfile"

    printf "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
    printf "$decodedname download complete\n"
    printf "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"

#    cat $decodedname.json | python -m json.tool > $decodedname.json
done

printf "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
printf "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
printf "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
printf "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
printf "Trending extract complete."
