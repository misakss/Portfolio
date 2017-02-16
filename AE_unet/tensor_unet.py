from __future__ import print_function, division, absolute_import, unicode_literals
from tensorflow.examples.tutorials.mnist import input_data

import tensorflow as tf
import numpy as np
import tkinter
import matplotlib.pyplot as plt 

# Input data
mnist = input_data.read_data_sets('MNIST_data', one_hot=True)

##################################################################
############################# Layers #############################
##################################################################

def weight_variable(shape, stddev=0.1):
    initial = tf.truncated_normal(shape, stddev=stddev)
    return tf.Variable(initial)

def weight_variable_deconv(shape, stddev=0.1):
    return tf.Variable(tf.truncated_normal(shape, stddev=stddev))

def bias_variable(shape):
    initial = tf.constant(0.1, shape=shape)
    return tf.Variable(initial)

def conv2d(x, W, keep_prob_):
    conv_2d = tf.nn.conv2d(x, W, strides=[1, 1, 1, 1], padding='SAME')
    return tf.nn.dropout(conv_2d, keep_prob_)

def deconv2d(x, W, stride,shape):
    x_shape = tf.shape(x)
    W_shape = tf.shape(W)
    if shape == 0:
        output_shape = tf.pack([x_shape[0], x_shape[1]*2, x_shape[2]*2, W_shape[2]])
    elif shape == 1:
        output_shape = tf.pack([x_shape[0], x_shape[1], x_shape[2], W_shape[2]])
    elif shape == 2:
        output_shape = tf.pack([x_shape[0], x_shape[1], x_shape[2], x_shape[3]//4])
    else:
        output_shape = tf.pack([x_shape[0], x_shape[1], x_shape[2], x_shape[3]//64])
    return tf.nn.conv2d_transpose(x, W, output_shape, strides=[1, stride, stride, 1], padding='SAME')

def max_pool(x, area):
    return tf.nn.max_pool(x, ksize=[1, area, area, 1], strides=[1, area, area, 1], padding='SAME')

def concat(x1, x2):
    return tf.concat(3, [x1, x2])

###################################################################
############################# Network #############################
###################################################################

sess = tf.InteractiveSession()

# Data variables
x = tf.placeholder(tf.float32, shape=[None, 784])
y_ = tf.placeholder(tf.float32, shape=[None, 784])

# To apply layer, reshape input to 4D tensor
x_image = tf.reshape(x, [-1,28,28,1])

# The placeholder makes sure that it is only dropout during training and not testing
keep_prob = tf.placeholder(tf.float32)

############################# Downsampling #############################

#------------- First layer -------------#

W_conv1 = weight_variable([5, 5, 1, 32])
b_conv1 = bias_variable([32])

# The convolution of the first layer, output size 28x28x32
conv1 = conv2d(x_image, W_conv1, keep_prob)

# Apply ReLU
h_conv1 = tf.nn.relu(conv1 + b_conv1)
print("Conv1", conv1.get_shape())

# The first pooling layer, output size 14x14x32
h_pool1 = max_pool(h_conv1, area = 2)
print("Pool1", h_pool1.get_shape())

#------------- Second layer -------------#

# Now 64 features for each 5x5 patch
W_conv2 = weight_variable([5, 5, 32, 64])
b_conv2 = bias_variable([64])

# The convolution of the second layer, output size 14x14x64
conv2 = conv2d(h_pool1, W_conv2, keep_prob)

# Apply ReLU
h_conv2 = tf.nn.relu(conv2 + b_conv2)
print("Conv2", h_conv2.get_shape())

# The second pooling layer, output size 7x7x64
h_pool2 = max_pool(h_conv2, area = 2)
print("Pool2", h_pool2.get_shape())

#------------- Third layer -------------#

# Now 64 features for each 1x1 patch
W_conv3 = weight_variable([1, 1, 64, 64])
b_conv3 = bias_variable([64])

# The convolution of the third layer, output size 7x7x64
conv3 = conv2d(h_pool2, W_conv3, keep_prob)
print("Conv3", conv3.get_shape())

# Apply ReLU
h_conv3 = tf.nn.relu(conv3 + b_conv3)

#------------- Fourth layer -------------#

# Now 64 features for each 1x1 patch, output size ?
W_conv4 = weight_variable([1, 1, 64, 5])
b_conv4 = bias_variable([5])

# The convolution of the fourth layer, output size 7x7x5
conv4 = conv2d(h_conv3, W_conv4, keep_prob)
print("Conv4", conv4.get_shape())

# Apply ReLU
h_conv4 = tf.nn.relu(conv4 + b_conv4)

############################# Upsampling #############################

# Start thinking backwards of the sizes/shapes

#------------- Fifth layer -------------#

W_deconv5 = weight_variable_deconv([1, 1, 64, 5])
b_deconv5 = bias_variable([64])

# The deconvolution of the fifth layer, output size 7x7x64
deconv5 = deconv2d(h_conv4, W_deconv5, 1, 1)
#print("Deconv5", output_shape)

# Apply ReLU
h_deconv5 = tf.nn.relu(deconv5 + b_deconv5)
print("Deconv5", h_deconv5.get_shape())

# The first unpooling layer, output size 14x14x64
W_unpool1 = weight_variable_deconv([2, 2, 64, 64])
b_unpool1 = bias_variable([64])

unpool1 = deconv2d(h_deconv5, W_unpool1, 2, 0)

# Apply ReLU
h_unpool1 = tf.nn.relu(unpool1 + b_unpool1)
#print("Unpool1", output_shape)
print("Unpool1", h_unpool1.get_shape())

#------------- Sixth layer -------------#

W_deconv6 = weight_variable_deconv([5, 5, 32, 128])
b_deconv6 = bias_variable([32])

# Concatenation for input, size 14x14x128
concat1 = concat(h_unpool1,h_conv2)

deconv6 = deconv2d(concat1, W_deconv6, 1, 2)

## The deconvolution of the sixth layer, output size 14x14x32
#deconv6 = deconv2d(h_unpool1, W_deconv6, 1, 1)
##print("Deconv6", output_shape)

# Apply ReLU
h_deconv6 = tf.nn.relu(deconv6 + b_deconv6)
print("Deconv6", h_deconv6.get_shape())

# The second unpooling layer, output size 28x28x32
W_unpool2 = weight_variable_deconv([2, 2, 32, 32])
b_unpool2 = bias_variable([32])

unpool2 = deconv2d(h_deconv6, W_unpool2, 2, 0)

# Apply ReLU
h_unpool2 = tf.nn.relu(unpool2 + b_unpool2)
#print("Unpool2", output_shape)
print("Unpool2", h_unpool2.get_shape())

#------------- Seventh layer -------------#

W_deconv7 = weight_variable_deconv([5, 5, 1, 64])
b_deconv7 = bias_variable([1])

# Concatenation for input, size 28x28x64
concat2 = concat(h_unpool2,h_conv1)

deconv7 = deconv2d(concat2, W_deconv7, 1, 3)

## The deconvolution of the sixth layer, output size 28x28x1  
#deconv7 = deconv2d(h_unpool2, W_deconv7, 1, 1)
##print("Deconv7", output_shape)

# Apply ReLU
h_deconv7 = tf.nn.relu(deconv7 + b_deconv7)
print("Deconv7", h_deconv7.get_shape())

#################################################################################
############################# Training & Evaluation #############################
#################################################################################

y_conv = tf.reshape(h_deconv7, [-1, 784])

error = tf.nn.l2_loss(y_ - y_conv)
train_step = tf.train.AdamOptimizer(1e-4).minimize(error) # The learning rate is smaller than normal
accuracy = tf.nn.l2_loss(y_ - y_conv)
sess.run(tf.global_variables_initializer())
for i in range(20000):
  batch = mnist.train.next_batch(50)
  if i%20 == 0:
    train_accuracy = accuracy.eval(feed_dict={
        x:batch[0], y_:batch[0], keep_prob: 1.0})
    print("step %d, training accuracy %g"%(i, train_accuracy))
    print("Saving test image to new_run_1.png")
    new_im = y_conv.eval(feed_dict={x: batch[0], y_: batch[0], keep_prob: 1.0})
    plt.imshow(new_im[1].reshape((28,28)))
    plt.savefig('new_run_1.png')
    print("Saved")
  train_step.run(feed_dict={x: batch[0], y_: batch[0], keep_prob: 0.8})







