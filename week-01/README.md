## Week 01: Perceptron

This week, our assignment is to make a neural network from scratch that only contains a single, linear neuron. We won't go into detail here as to what that means but encourage you to check out the blog post accompanying this assignment that gives a good description.

For a single linear neuron, the neuron's output simply is a weighted sum of a linear input vector. Then, with the proper implementation of gradient decent, your neuron can learn the proper weights to get to the desired output.

#### The Assignment 
Imagine you go to the grocery store many times, and each time you buy the same five items but in different quantities, and each time your receipt only tells you the total for your entire purchase. So, you want to use this single linear neuron to help you figure out the price of each individual item. (Obviously, this is a system of linear equations that you could just solve with algebra, but that's not the point. The point is to use this to get a grasp of how a neuron really learns, so you can then have an intuition for larger, black-box networks.)

In this example, your input vector x represents the quantities of each item you purchased during one run to the store, and the unknown weights are their prices. To do this, you need to:

1. initialize a random set of weights (or prices) and create your neuron's estimate for the grocery bill total (the weighted sum).

2. You can then compare this estimated total to the actual total, which is given to you, with the cost function (see blog post)

3. Then, use the analytical gradients for cost with respect to each weight to update the weights.

4. With your new weights, go through the whole process again of estimation, cost calculation, and weight update. Do this until your weights seem to settle on "steady" values, which now represent the cost of each item!

We've included here a .csv file that represents 100 hypothetical grocery runs with the quantity of each of five items purchased along with the total price for each grocery run. We made this data with just some quick number generation, so feel free to add to it to see how addition or subtraction of training data represents your result.

If you're stuck at all, really default to the blog post, as there is sample code there for a slightly simpler version of this problem, and all the math for gradient calculation and everything is gone over in detail. The sample code is written in python, but feel free to use whichever language you wish. Once you have a trainable neuron, really go crazy, and see how different parameters affect its performance. Make plots, and come ready to share what you've learned.


## References

https://towardsdatascience.com/power-of-a-single-neuron-perceptron-c418ba445095
