#!/usr/bin/env bash

set;
pwd;
bash jobs.sh --jobtype="fulltime"
echo '[' > ./archive/fulltime.alljobs.json.tmp
cat ./archive/fulltime.alljobs.json  | tr -d '|' | tr -d '[' | tr -d ']' | sed 's/[0-9]* hours ago/0/g' | sed 's/ days ago//g' | sed 's/ day ago//g' | sed $'s/[^[:print:]\t]//g' >> ./archive/fulltime.alljobs.json.tmp
echo ']' >> ./archive/fulltime.alljobs.json.tmp
mv ./archive/fulltime.alljobs.json ./archive/fulltime.alljobs.json.orig

bash jobs.sh --jobtype="parttime"
echo '[' > ./archive/parttime.alljobs.json.tmp
cat ./archive/parttime.alljobs.json | tr -d '|' | tr -d '[' | tr -d ']' | sed 's/[0-9]* hours ago/0/g' | sed 's/ days ago//g' | sed 's/ day ago//g' | sed $'s/[^[:print:]\t]//g'  >> ./archive/parttime.alljobs.json.tmp
echo ']' >> ./archive/parttime.alljobs.json.tmp
mv ./archive/parttime.alljobs.json ./archive/parttime.alljobs.json.orig

bash jobs.sh --jobtype="contract"
echo '[' > ./archive/contract.alljobs.json.tmp
cat ./archive/contract.alljobs.json | tr -d '|' | tr -d '[' | tr -d ']' | sed 's/[0-9]* hours ago/0/g' | sed 's/ days ago//g' | sed 's/ day ago//g' | sed $'s/[^[:print:]\t]//g' >> ./archive/contract.alljobs.json.tmp
echo ']' >> ./archive/contract.alljobs.json.tmp

bash jobs.sh --jobtype="internship"
echo '[' > ./archive/internship.alljobs.json.tmp
cat ./archive/internship.alljobs.json | tr -d '|' | tr -d '[' | tr -d ']' | sed 's/[0-9]* hours ago/0/g' | sed 's/ days ago//g' | sed 's/ day ago//g' | sed $'s/[^[:print:]\t]//g' >> ./archive/internship.alljobs.json.tmp
echo ']' >> ./archive/internship.alljobs.json.tmp

bash jobs.sh --jobtype="temporary"
echo '[' > ./archive/temporary.alljobs.json.tmp
cat ./archive/temporary.alljobs.json | tr -d '|' | tr -d '[' | tr -d ']' | sed 's/[0-9]* hours ago/0/g' | sed 's/ days ago//g' | sed 's/ day ago//g' | sed $'s/[^[:print:]\t]//g' >> ./archive/temporary.alljobs.json.tmp
echo ']' >> ./archive/temporary.alljobs.json.tmp


mv ./archive/fulltime.alljobs.json.tmp ./archive/fulltime.alljobs.json
mv ./archive/parttime.alljobs.json.tmp ./archive/parttime.alljobs.json
mv ./archive/contract.alljobs.json.tmp ./archive/contract.alljobs.json
mv ./archive/internship.alljobs.json.tmp ./archive/internship.alljobs.json
mv ./archive/temporary.alljobs.json.tmp ./archive/temporary.alljobs.json

