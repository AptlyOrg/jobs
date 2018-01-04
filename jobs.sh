#!/usr/bin/env bash

declare -a orgs=(`cat ho.txt`)
declare -a jobtypes=( fulltime parttime contract internship temporary )  # Defined by the Indeed API

# Initialize command line args
jobtype=''
verbosity=0
location=''
match=''
returnValue=0;

containsElement() {
    match="$1"
    returnValue=1
    for e in ${jobtypes[@]}; do
        if [ "$e" == "$match" ]; then
            returnValue=0
        fi
    done
    return $returnValue
}

die() {
    echo "$1" >&2
    for e in ${jobtypes[@]}; do
        echo "$e" >&2
    done
    exit 1
}

for var in $@; do
    case $var in
        -h|-\?|--help)
            show_help                               # Display a usage synopsis.
            exit
            ;;
        --jobtype=?*)
            jobtype=${var#*=};
            containsElement "$jobtype"
            if [ "$returnValue" -eq 1 ]; then
                message='ERROR: --jobtype must be one of the following:'
                die "$message"
            fi
        ;;
        --location=?*)
            location=${var#*=};                     # Delete everything up to "=" and assign remainder
            if [ "${#location}" -ne 5 ]; then
                die 'ERROR: "--location" does not look quite right'
            fi
        ;;
        --verbosity)
            verbosity=1;
        ;;
        --)                                         # End of all options.
            shift
            break
            ;;
        -?*)
            printf 'WARN: Unknown option (ignored): %s\n' "$1" >&2
            ;;
        *)                                          # Default case: No more options, break out of loop
            break
    esac
    shift
done

if [ "$verbosity" -eq 1 ];  then echo 'Verbosity is ON';fi
if [ "$jobtype" ]; then
    echo 'Job Type was found, using:' "$jobtype";
    jobTypeFile="$jobtype""."
fi
if [ "$location" ]; then
    echo 'Location was found, using:' "$location";
    locationFile="$location""."
fi

# Intialize
datestamp=`date`
totaljobcount=0
fileroot="./archive"
summaryfile=$fileroot"/"$locationFile$jobTypeFile"summary.txt"
alljobs=$fileroot"/"$locationFile$jobTypeFile"alljobs.json"



# Ephemeral file creation
printf '' > $summaryfile

for i in "${orgs[@]}"
do
    decodedname=`echo ${i//%26/&} | tr -d '.' | tr '&' '-' | tr "[:upper:]" "[:lower:]"`
    decodednameFile=$fileroot"/"$locationFile$jobTypeFile$decodedname".json"
    limitcount=25
    startstring=""

    # Pull a single record to determine size of the result set
    jobcount=$(curl --silent --request GET  \
        "https://indeed-indeed.p.mashape.com/apisearch?publisher=127676247689188&format=json&jt=$jobtype&l=$location&v=2&limit=1&q=company:\"$i\"" \
          -H 'Accept: application/json' \
          -H 'Cache-Control: no-cache' \
          -H 'X-Mashape-Key: YjtQBqSWKmmshwn5c06JmE2Ut5VSp1X5Z25jsn9laldG042Uoy' \
        | grep totalResults | jq -r '.totalResults')

    #  Probably unnecessary -- -H 'Postman-Token: bc9953ce-f706-08a3-bbf2-be05956fa3d2' \

    totaljobcount=$(($totaljobcount + $jobcount));
    printf "$decodedname -- $jobcount\n" >> "$summaryfile"


    # Report back whether jobs were found or not
    if [ "$jobcount" -eq "0" ]
    then
        printf "\n\nPrepping $decodedname... hmmmm, no jobs found... <sigh>\n"
        printf "Suspended download.\n"
    else
        printf "\n\nPrepping $decodedname...\t $jobcount job(s) found!\n"
        printf '' > "$decodednameFile"
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
     "https://indeed-indeed.p.mashape.com/apisearch?publisher=127676247689188&format=json&jt=$jobtype&l=$location&v=2$startstring&limit=$limitcount&q=company:\"$i\"" \
          -H 'Accept: application/json' \
          -H 'Cache-Control: no-cache' \
          -H 'X-Mashape-Key: YjtQBqSWKmmshwn5c06JmE2Ut5VSp1X5Z25jsn9laldG042Uoy' \
         | tee -a "$decodednameFile" "$alljobs"

    #  Probably unnecessary -- -H 'Postman-Token: bc9953ce-f706-08a3-bbf2-be05956fa3d2' \

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
printf "  SUMMARY REPORT saved to file: $summaryfile\n"
printf "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
printf "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"

cat "$summaryfile"
printf "Total jobs consumed on $datestamp: <drum roll>... $totaljobcount\n\n"
