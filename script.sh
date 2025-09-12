#!/bin/bash
# INFO-B 473/B573 Assignment 1
# Author: [Your Name]
# Version: 1.0

# Step 1: Go to home directory
cd ~

# Step 2: Create and enter Informatics_573 folder
mkdir -p Informatics_573
cd Informatics_573

# Step 3: Download UCSC index page
BASE_URL="https://hgdownload.soe.ucsc.edu/goldenPath/hg38/chromosomes/"
wget -q "${BASE_URL}" -O index.html

# Step 4: Extract only chr1_* secondary assemblies (exclude chr1.fa.gz)
grep -oP 'href="\Kchr1_[^"]+\.fa\.gz(?=")' index.html > chr1_list.txt

# Step 5: Download each file
while read -r file; do
    echo "Downloading $file..."
    wget "${BASE_URL}${file}"
done < chr1_list.txt

# Step 6: Unzip all downloaded files
gunzip chr1_*.fa.gz

# Step 7: Create summary file
touch data_summary.txt

# Step 8: Append file metadata
echo "=== File Details ===" >> data_summary.txt
ls -lh --time-style=long-iso chr1_* >> data_summary.txt

# Step 9: Append first 10 lines of each file
echo -e "\n=== First 10 Lines of Each Assembly ===" >> data_summary.txt
for file in chr1_*; do
    echo -e "\n--- $file ---" >> data_summary.txt
    head -n 10 "$file" >> data_summary.txt
done

# Step 10: Append line counts
echo -e "\n=== Line Counts ===" >> data_summary.txt
for file in chr1_*; do
    count=$(wc -l < "$file")
    echo "$file: $count lines" >> data_summary.txt
done

# Step 11: Clean up
rm index.html chr1_list.txt

echo "✅ Script completed. Check 'data_summary.txt'."

