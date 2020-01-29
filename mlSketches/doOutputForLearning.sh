#!/bin/bash
for fullName in $(ls ./input/)
do
name=${fullName%.bmp}
./getPosByTemplate.py ./template.bmp input/${fullName} "output/"${name}L.bmp "output/"${name}R.bmp
done
