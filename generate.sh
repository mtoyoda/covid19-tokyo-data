#!/bin/bash

# git clone from tokyo-metropolitan-gov/covid19 at the first time
# git pull if covid19 has already been cloned
if [ ! -d covid19 ]; then
    git clone https://github.com/tokyo-metropolitan-gov/covid19
else
    cd covid19
    git pull
    cd ..
fi

cd covid19

# Scan commit log and extract commits that update data
git log | grep -i -B 4 "update data" | grep "commit " > ../commit_ids

# Extract and copy all versions of "data/patients.json"
perl ../history_of_patient_json.pl ../commit_ids

# Convert JSON files to a CSV file
cd ../district-wise-patients
perl ../parse_json_0.pl json/patient.json.0001.* > date_district_num_0.csv
ls -1 json/* | tail -n +2 | perl ../parse_json_1.pl > date_district_num_1.csv
tail -n +2 date_district_num_1.csv | cat date_district_num_0.csv - > date_district_num.csv

# Clean up CSV file by a patch made manually
patch -b date_district_num.csv date_district_num.csv.patch

# Generate daily diff file
perl ../diff.pl < date_district_num.csv > date_district_diff.csv
