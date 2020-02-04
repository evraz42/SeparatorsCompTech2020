#!/usr/bin/env python

import argparse
import cv2
import numpy as np
from detector import *

if __name__ == "__main__" :
    parser = argparse.ArgumentParser()
    parser.add_argument('config_path', action="store", help="configuration path for network")
    parser.add_argument('weights_path', action="store", help="weights path for network")
    parser.add_argument('w_flag', action="store", help="Width of one flag")
    parser.add_argument('h_flag', action="store", help="Height of one flag")
    parser.add_argument('img', action="store", help="Base image")
    parser.add_argument('output_l', action="store", help="Output path for left flag")
    parser.add_argument('output_r', action="store", help="Output path for right flag")

    args = parser.parse_args()
    
    img = cv2.imread(args.img, cv2.IMREAD_COLOR)
    net = cv2.dnn.readNet(args.weights_path, args.config_path)
    top_left, bottom_right = find_template_by_net(img, net)
    if(top_left[0] == None):
        print(0)
        exit(1)
    center_top = (round((top_left[0] + bottom_right[0]) / 2.), top_left[1])
    (l_top_left, l_bottom_right), (r_top_left, r_bottom_right) = \
        get_pos_of_flags(center_top, int(args.w_flag), int(args.h_flag))
    if (l_top_left[0] < 0 or 
        l_top_left[1] < 0 or 
        r_bottom_right[0] > img.shape[1] or 
        r_bottom_right[1] > img.shape[0]):
        print(0)
        exit(1)
    print(l_top_left, l_bottom_right, r_top_left, r_bottom_right)
    save_flag_image(img, l_top_left, l_bottom_right, args.output_l)
    save_flag_image(img, r_top_left, r_bottom_right, args.output_r)