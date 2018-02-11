#!/usr/bin/env bash

curl -s --request GET "http://www.indeed.com/viewjob?jk=ce6034e730bde1a6" | tidy --quiet yes --show-warnings no --show-errors 0 --show-info no --wrap 0 --wrap-attributes no --wrap-script-literals no | xmllint --html --xpath '//span[@id="job_summary"]' - 2>error.txt
curl -s --request GET "http://www.indeed.com/viewjob?jk=c1161683a10e8789" | xmllint --html --xpath '//tr/td/div/span[@class="location"]' - 2>error.txt
curl -s --request GET "http://www.indeed.com/viewjob?jk=ce6034e730bde1a6" | xmllint --html --xpath '//span[@id="job_summary"]' - 2>error.txt

