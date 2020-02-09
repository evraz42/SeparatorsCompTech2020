import tensorflow as tf
from termcolor import colored
import numpy as np

class Model(object):

    def __init__(self, path):
        print(colored('[LOAD]', 'green'), 'Classificator Net Loading...')
        # Initalization Gender Net
        self.left_nn_net = tf.keras.models.load_model(path)


    def predict(self, img):
        # Normalization
        img = img / 255.0
        img = np.expand_dims(img, axis=0)
        img = np.expand_dims(img, axis=3)

        self.prediction = self.left_nn_net.predict(img)
        self.all_value = []
        for i in self.prediction[0]:
            self.new_val = float(str(i)) * 100
            self.new_val = round(self.new_val, 4)
            self.all_value.append(self.new_val)
        #print('\nPrediction \n{}'.format(self.all_value))

        return self.all_value
