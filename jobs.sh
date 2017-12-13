#!/usr/bin/env bash

declare -a arr=("Commerce%20Bank" "DST%20Systems" "C2FO" "Kansas%20City%20Public%20Library" "First%20National")   # "element3"

for i in "${arr[@]}"
do

    decodedname=`echo $i| tr -d "%20"`
    echo "Retreiving $decodedname..."
    printf '' > $decodedname.json

    curl -X GET \
     "https://indeed-indeed.p.mashape.com/apisearch?publisher=127676247689188&format=json&l=&v=2&q=company:\"$i\"&limit=25" \
      -H 'Accept: application/json' \
      -H 'Cache-Control: no-cache' \
      -H 'Postman-Token: bc9953ce-f706-08a3-bbf2-be05956fa3d2' \
      -H 'X-Mashape-Key: YjtQBqSWKmmshwn5c06JmE2Ut5VSp1X5Z25jsn9laldG042Uoy' \
        | python -m json.tool >> $decodedname.json

done

echo "...done"

# echo "${arr[0]}", "${arr[1]}"
