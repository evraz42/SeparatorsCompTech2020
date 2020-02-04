import numpy as np
import cv2
import subprocess
from crop_image import crop_img_on_left_right
from PIL import Image
import tensorflow as tf
import os

INDEX_FOR_TEMPLATES = 0
PATH_TO_TEMPLATES = '/Users/vakurin/Documents/Study/Code/TF2/comtech/dataset/template/'
FLAGS_FIND_PREVIOUS = False



def list_temp_directories(path):
    template_directory = os.listdir(path)
    return template_directory




template_directory = list_temp_directories(PATH_TO_TEMPLATES)

# Source 1 - (1 - 307)
# Source 2 - (1 - 80)
# Source 3 - (1 - 316)

# Assign template and target images
template = cv2.imread(path_to_template + template_directory[INDEX_FOR_TEMPLATES])
image    = cv2.imread('/Users/vakurin/Documents/Study/Code/TF2/comtech/dataset/source_data/source1_150.bmp')

# Convert to grayscale
imageGray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
templateGray = cv2.cvtColor(template, cv2.COLOR_BGR2GRAY)

# Find template
result = cv2.matchTemplate(imageGray, templateGray, cv2.TM_CCOEFF)
min_val, max_val, min_loc, max_loc = cv2.minMaxLoc(result)
top_left = max_loc
h, w = templateGray.shape
bottom_right = (top_left[0] + w, top_left[1] + h)

# Track Array(Box) = [36, 235, 713, 1185]
box = [top_left[0], top_left[1], bottom_right[0], bottom_right[1]]
left_wings, right_wings = crop_img_on_left_right(image, box)
#cv2.imwrite('./imageLeft1.bmp', left_wings)
#cv2.imwrite('./imageRight2.bmp', right_wings)


def prediction_model(mode='left'):
    if mode == 'left':
        NAME_MODEL = 'models/Comtech_First_Model_90_Left_8.h5'
    elif mode == 'right':
        NAME_MODEL = 'models/Comtech_First_Model_99_Right_8.h5'
    model = tf.keras.models.load_model(NAME_MODEL)
    prediction = model.predict(left_wings)
    all_value = []
    for i in prediction[0]:
        #new_val = round(i, 4)
        new_val = float(str(i)) * 100
        new_val = round(new_val, 4)
        all_value.append(new_val)
    print(all_value)
    #trash = all_value[7]
    max_index = np.argmax(all_value)
    return max_index, all_value


max_index, all_value = prediction_model()

if max_index == 7:
    print('\nNot Defined')
    print('Trash Found')
    global INDEX_FOR_TEMPLATES += 1

else:
