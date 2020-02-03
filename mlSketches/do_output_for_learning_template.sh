#!/bin/bash
for fullName in $(ls ./input/)
do
name=${fullName%.jpg}
./get_pos_by_template.py ./template.bmp 245 310 input/${fullName} "output_template/"${name}L.jpg "output_template/"${name}R.jpg
done
