#!/bin/sh

files=`cat done.txt`
schema=piccolo2d-xhtml.rnc

# create a schema of use structures:
trang -I xml $files $schema

# validate the files
xmllint --html --noout $files
echo "Checked $files"
