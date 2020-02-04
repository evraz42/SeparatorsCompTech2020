#!/usr/bin/env python

import cv2
import numpy as np

def find_template_by_matchTemplate(img, template):
    scale = 1 # percent of original size
    ksize = (7, 7)
    width = int(img.shape[1] * scale)
    height = int(img.shape[0] * scale)
    dim = (width, height) 
    img1 = cv2.blur(cv2.resize(img, dim), ksize)
    width = int(template.shape[1] * scale)
    height = int(template.shape[0] * scale)
    dim = (width, height) 
    template1 = cv2.blur(cv2.resize(template, dim), ksize)
    result = cv2.matchTemplate(img1, template1, cv2.TM_CCORR_NORMED)
    min_val, max_val, min_loc, max_loc = cv2.minMaxLoc(result)
    top_left = max_loc
    w, h = template.shape[::-1]
    bottom_right = (top_left[0] + w, top_left[1] + h)
    return top_left, bottom_right

def getOutputsNames(net):
    layersNames = net.getLayerNames()
    return [layersNames[i[0] - 1] for i in net.getUnconnectedOutLayers()]

def find_template_by_net(image, net):
    blob = cv2.dnn.blobFromImage(image, 1.0/255.0, (416,416), [0,0,0], True, crop=False)
    width = image.shape[1]
    height = image.shape[0]
    net.setInput(blob)
    outs = net.forward(getOutputsNames(net))
    confidences = []
    boxes = []
    conf_threshold = 0.8
    nms_threshold = 0.4
    for out in outs:
        for detection in out:
        #each detection  has the form like this [center_x center_y width height obj_score class_1_score class_2_score ..]
            confidence = detection[4]
            if confidence > conf_threshold:
                center_x = int(detection[0] * width)
                center_y = int(detection[1] * height)
                w = int(detection[2] * width)
                h = int(detection[3] * height)
                x = center_x - w / 2
                y = center_y - h / 2
                confidences.append(float(confidence))
                boxes.append([x, y, w, h])
                break
    # apply  non-maximum suppression algorithm on the bounding boxes
    # indices = cv2.dnn.NMSBoxes(boxes, confidences, conf_threshold, nms_threshold)
    # print(indices)
    if(len(boxes) == 0):
        return (None, None), (None, None)
    box = boxes[0]
    x = box[0]
    y = box[1]
    w = box[2]
    h = box[3]
    top_left = (int(x), int(y))
    bottom_right = (int(top_left[0] + w), int(top_left[1] + h))
    return top_left, bottom_right

def get_pos_of_flags(center_top, w, h):
    l_top_left = (int(center_top[0] - w), center_top[1])
    l_bottom_right = (center_top[0], center_top[1] + h)
    r_top_left = (center_top[0], center_top[1])
    r_bottom_right = (center_top[0] + w, center_top[1] + h)
    return ((l_top_left, l_bottom_right), (r_top_left, r_bottom_right)) 

def save_flag_image(img, top_left, bottom_right, name):
    flag_image = img[top_left[1] : bottom_right[1], top_left[0] : bottom_right[0]]
    cv2.imwrite(name, flag_image)

