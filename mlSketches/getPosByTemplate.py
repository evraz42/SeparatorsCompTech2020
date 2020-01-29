#!/usr/bin/env python

import argparse
import cv2
import numpy as np
from matplotlib import pyplot as plt

def find_template(img, template):
    result = cv2.matchTemplate(img.copy(), template, cv2.TM_CCORR_NORMED)
    min_val, max_val, min_loc, max_loc = cv2.minMaxLoc(result)
    top_left = max_loc
    w, h = template.shape[::-1]
    bottom_right = (top_left[0] + w, top_left[1] + h)
    return top_left, bottom_right

def get_pos_of_flags(top_left, w, h):
    l_top_left = (int(top_left[0] - w * 0.3), top_left[1])
    l_bottom_right = (l_top_left[0] + w, l_top_left[1] + h)
    r_top_left = (l_bottom_right[0], l_top_left[1])
    r_bottom_right = (r_top_left[0] + w, r_top_left[1] + h)
    return ((l_top_left, l_bottom_right), (r_top_left, r_bottom_right)) 

def saveFlagImage(img, top_left, bottom_right, name):
    flagImage = img[top_left[1] : bottom_right[1], top_left[0] : bottom_right[0]]
    cv2.imwrite(name, flagImage)

if __name__ == "__main__" :
    parser = argparse.ArgumentParser()
    parser.add_argument('template', action="store", help="Template for finding gear")
    parser.add_argument('img', action="store", help="Base image")
    parser.add_argument('outputL', action="store", help="Output path for left flag")
    parser.add_argument('outputR', action="store", help="Output path for right flag")
    args = parser.parse_args()
    
    template = cv2.imread(args.template, cv2.IMREAD_GRAYSCALE)
    img = cv2.imread(args.img, cv2.IMREAD_GRAYSCALE)
    top_left, bottom_right = find_template(img, template)

    w = int(template.shape[1] * 0.75)
    h = int(template.shape[0] * 2)
    (l_top_left, l_bottom_right), (r_top_left, r_bottom_right) = get_pos_of_flags(top_left, w, h)
    print(l_top_left, l_bottom_right, r_top_left, r_bottom_right)
    saveFlagImage(img, l_top_left, l_bottom_right, args.outputL)
    saveFlagImage(img, r_top_left, r_bottom_right, args.outputR)

    # dst = cv2.cvtColor(img, cv2.COLOR_GRAY2BGR)
    # cv2.rectangle(dst, l_top_left, l_bottom_right, color=(0, 255, 0), thickness=2)
    # cv2.rectangle(dst, r_top_left, r_bottom_right, color=(0, 0, 255), thickness=2)
    # plt.figure(figsize=(20,10))
    # plt.imshow(dst)
    # plt.show()
