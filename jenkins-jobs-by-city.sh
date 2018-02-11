#!/usr/bin/env bash

export PATH=$PATH:.

set;
pwd;
bash jobs.sh --location="kansas+city%2C+MO"
bash jobs.sh --location="st+louis%2C+MO"
bash jobs.sh --location="omaha%2C+NE"
echo '[' > ./archive/alljobs.json
cat ./archive/*.alljobs.json | tr -d '|' | tr -d '[' | tr -d ']' | sed 's/[0-9]* hours ago/0/g' | sed 's/ days ago//g' | sed 's/ day ago//g' >> ./archive/alljobs.json
echo ']' >> ./archive/alljobs.json
