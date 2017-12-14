#!/usr/bin/env bash

declare -a arr=("Commerce-Bank" "DST-Systems" "C2FO" "Kansas-City-Public-Library" "First-National-Bank-of-Omaha")

for i in "${arr[@]}"
do

    decodedname=`echo $i| tr -d "%20"`
    echo "Retreiving $decodedname..."
    printf '' > $decodedname.json

    curl -X GET \
     "https://indeed-indeed.p.mashape.com/apisearch?publisher=127676247689188&format=json&l=&v=2&start=[0-24:24]&limit=25&q=company:\"$i\"" \
      -H 'Accept: application/json' \
      -H 'Cache-Control: no-cache' \
      -H 'Postman-Token: bc9953ce-f706-08a3-bbf2-be05956fa3d2' \
      -H 'X-Mashape-Key: YjtQBqSWKmmshwn5c06JmE2Ut5VSp1X5Z25jsn9laldG042Uoy' \
         >> $decodedname.json

#    cat $decodedname.json | python -m json.tool > $decodedname.json
done

echo "...done"
