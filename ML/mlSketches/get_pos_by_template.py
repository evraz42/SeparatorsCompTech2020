#!/usr/bin/env python

import argparse
import cv2
import numpy as np
from detector import *

if __name__ == "__main__" :
    parser = argparse.ArgumentParser()
    parser.add_argument('template', action="store", help="Template for finding gear")
    parser.add_argument('w_flag', action="store", help="Width of one flag")
    parser.add_argument('h_flag', action="store", help="Height of one flag")
    parser.add_argument('img', action="store", help="Base image")
    parser.add_argument('output_l', action="store", help="Output path for left flag")
    parser.add_argument('output_r', action="store", help="Output path for right flag")
    args = parser.parse_args()
    
    template = cv2.imread(args.template, cv2.IMREAD_GRAYSCALE)
    img = cv2.imread(args.img, cv2.IMREAD_GRAYSCALE)
    top_left, bottom_right = find_template_by_matchTemplate(img, template)
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

    # dst = cv2.cvtColor(img, cv2.COLOR_GRAY2BGR)
    # cv2.rectangle(dst, l_top_left, l_bottom_right, color=(0, 255, 0), thickness=2)
    # cv2.rectangle(dst, r_top_left, r_bottom_right, color=(0, 0, 255), thickness=2)
    # cv2.rectangle(dst, top_left, bottom_right, color=(255, 255, 0), thickness=2)
    # import matplotlib.pyplot as plt
    # plt.figure(figsize=(20,10))
    # plt.imshow(dst)
    # plt.show()
