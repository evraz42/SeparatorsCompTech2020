import numpy as np
import cv2
import subprocess
from crop_image import crop_img_on_left_right
from PIL import Image
import tensorflow as tf
import os
import classificator

# Disable Warnings TensorFlow
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'

assert float(tf.__version__[0:3]) > 2.0, ('Please Update TensorFlow')

INDEX_FOR_TEMPLATES = 0
PATH_TO_TEMPLATES = './dataset/template/'
FLAGS_FIND_PREVIOUS = False

def _draw_box_label(img, prediction_left, wings_pos_left,
                         prediction_right, wings_pos_right,
                         bbox_cv2, box_color=(0, 0, 255)):
    '''
    Helper funciton for drawing the bounding boxes and the labels
    bbox_cv2 = [left, top, right, bottom]
    '''


    font = cv2.FONT_HERSHEY_SIMPLEX
    font_size = 0.3
    font_color = (255, 255, 255)
    left, top, right, bottom = bbox_cv2[0], bbox_cv2[1], bbox_cv2[2], bbox_cv2[3]

    # # Draw the bounding box
    cv2.rectangle(img, (left, top), (right, bottom), box_color, 4)

    # Draw a filled box on top of the bounding box (as the background for the labels)
    cv2.rectangle(img, (left-2, top-20), (right+2, top), box_color, -1, 1)

    # Output the labels that show the id and object
    text_pred_left = 'Left ' + str(prediction_left) + ' %'
    cv2.putText(img, text_pred_left, (left, top-10), font, font_size, font_color, 1, cv2.LINE_AA)
    text_wings_pos = 'Wings Position ' + str(wings_pos_left)
    cv2.putText(img, text_wings_pos, (left, top-0), font, font_size, font_color, 1, cv2.LINE_AA)

    text_pred_right= 'Right ' + str(prediction_right) + ' %'
    cv2.putText(img, text_pred_right, (right-100, top-10), font, font_size, font_color, 1, cv2.LINE_AA)
    text_wings_pos_right = 'Wings Position ' + str(wings_pos_right)
    cv2.putText(img, text_wings_pos_right, (right-100, top-0), font, font_size, font_color, 1, cv2.LINE_AA)

    return img

# Show All Files  In Temp Directory
def _list_temp_directories(path: str):
    onlyfiles = [f for f in os.listdir(path) if os.path.isfile(os.path.join(path, f)) if f.endswith('.bmp')]
    all_files = []
    for ele in sorted(onlyfiles):
        all_files.append(ele)
    return all_files


def _prediction_model(image, mode='left'):
    if mode == 'left':
        all_pred_values = left_model.predict(image)

    elif mode == 'right':
        all_pred_values = right_model.predict(image)

    max_index = 0
    all_value = 100

    wings_position = np.argmax(all_pred_values)

    prediction = all_pred_values[wings_position]

    wings_position += 1
    print('Wings Position', wings_position)

    return wings_position, prediction


def result_of_classification(index:int, templates_index=0, flags_prev=False):
    if index == 7:
        print('\nNot Defined')
        print('Trash Found')
        if FLAGS_FIND_PREVIOUS:
            print('Get Previous Coordinates')
        global INDEX_FOR_TEMPLATES
        INDEX_FOR_TEMPLATES += 1
        # TODO:: Create to call next template
    else:
        _prediction_model(right_wings, mode='right')




def pipeline(img, template_directory):

    # Convert to grayscale
    imageGray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

    template = cv2.imread(PATH_TO_TEMPLATES + template_directory[INDEX_FOR_TEMPLATES])
    print('Call Template №', template_directory[INDEX_FOR_TEMPLATES])
    templateGray = cv2.cvtColor(template, cv2.COLOR_BGR2GRAY)

    # Find template
    result = cv2.matchTemplate(imageGray, templateGray, cv2.TM_CCOEFF)
    min_val, max_val, min_loc, max_loc = cv2.minMaxLoc(result)
    top_left = max_loc
    h, w = templateGray.shape
    bottom_right = (top_left[0] + w, top_left[1] + h)

    # Track Array(Box) = [36, 235, 713, 1185]
    box = [top_left[0], top_left[1], bottom_right[0] + 50, bottom_right[1]+50]
    left_wings, right_wings = crop_img_on_left_right(img, box)

    # Prediction Models
    wings_pos_left, pred_left = _prediction_model(left_wings)
    wings_pos_right, pred_right = _prediction_model(right_wings, mode='right')

    # TODO::Check Wings Position if class 8

    img = _draw_box_label(img, pred_left, wings_pos_left, pred_right, wings_pos_right, box)

    cv2.imshow('frame', img)

    return img



if __name__ == '__main__':

    left_model = classificator.Model('models/Comtech_First_Model_90_Left_8.h5')
    right_model = classificator.Model('models/Comtech_First_Model_99_Right_8.h5')

    video = cv2.VideoCapture('dataset/video/source2.avi')

    # Templates
    template_directory = _list_temp_directories(PATH_TO_TEMPLATES)
    print(template_directory)

    while(True):
        ret, img = video.read()
        pipeline(img, template_directory)

        if cv2.waitKey(1) & 0xFF == ord('q'):
            break


    video.release()
    cv2.destroyAllWindows()
