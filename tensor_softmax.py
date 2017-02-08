import tensorflow as tf
from tensorflow.examples.tutorials.mnist import input_data

# Input data
mnist = input_data.read_data_sets('MNIST_data', one_hot=True)

# Backend connection to c++, or Session
sess = tf.InteractiveSession()

#---------------------------------------- MODEL ----------------------------------------

# Softmax Regression Model, Create nodes for input images and target output classes, for the computation graph
x = tf.placeholder(tf.float32, shape=[None, 784])
y_ = tf.placeholder(tf.float32, shape=[None, 10])

# Define the variables Weights and Biases
W = tf.Variable(tf.zeros([784,10]))
b = tf.Variable(tf.zeros([10]))

# Initialize variables before using them in a session
sess.run(tf.global_variables_initializer())

# Implement regression model
y = tf.matmul(x,W) + b

# Calculate the loss that will be used for training
cross_entropy = tf.reduce_mean(tf.nn.softmax_cross_entropy_with_logits(y, y_))

#---------------------------------------- TRAINING ----------------------------------------

# Optimizer, SGD step 0.5
train_step = tf.train.GradientDescentOptimizer(0.5).minimize(cross_entropy)

# Train by iterate the train_step
for i in range(1000):
  batch = mnist.train.next_batch(100)
  train_step.run(feed_dict={x: batch[0], y_: batch[1]})

#---------------------------------------- EVALUATION ----------------------------------------

# Check if prediction matches the truth
correct_prediction = tf.equal(tf.argmax(y,1), tf.argmax(y_,1))

# Accuracy of the model
accuracy = tf.reduce_mean(tf.cast(correct_prediction, tf.float32))

# Print the evalutation of the model on the test data
print(accuracy.eval(feed_dict={x: mnist.test.images, y_: mnist.test.labels}))

