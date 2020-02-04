#!/bin/bash
for fullName in $(ls ./input/)
do
name=${fullName%.jpg}
path_weight=${1}
name_weight=${path_weight%.weights}
./get_pos_by_net.py ./cfg/yolov3-tiny.cfg ./weights/${path_weight} 245 310 input/${fullName} "output_"${name_weight}"/"${name}L.jpg "output_"${name_weight}"/"${name}R.jpg
done
