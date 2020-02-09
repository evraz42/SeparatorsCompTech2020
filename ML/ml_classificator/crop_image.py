import cv2
import numpy as np

def crop_img_on_left_right(img, track_array, width_need=245 , height_need=310):
    '''
        Function Crop Image And Resize

        Variables For Update Padding
        plus and minus

        Return two slice with coordinates
    '''
    # Save new coordinates
    X1, Y1, X2, Y2 = [track_array[0], track_array[1], track_array[2], track_array[3]]

    middle_image = (X2 - X1) // 2


    # img [y1:y2, x1:x2]
    left_image = img[Y1 : Y2 , X1 + middle_image - 245 : X1 + middle_image]
    left_image = cv2.resize(left_image, (310, 245))
    left_image = cv2.cvtColor(left_image, cv2.COLOR_BGR2GRAY)

    right_image = img[Y1 : Y2, X1 + middle_image : X1 + middle_image + 245]
    right_image = cv2.resize(right_image, (310, 245))
    right_image = cv2.cvtColor(right_image, cv2.COLOR_BGR2GRAY)


    return left_image, right_image
