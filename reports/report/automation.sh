#!/bin/bash
kubescape scan framework nsa --format pdf --output "/home/ditiss/report/$(date +%F).pdf" > /dev/null 2>&1 
echo "Please find the attached PDF." | mutt -s "Subject: PDF Attachment" -a /home/ditiss/report/$(date +%F).pdf -- probot7757@gmail.com
