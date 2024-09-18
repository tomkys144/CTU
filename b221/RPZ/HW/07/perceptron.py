#!/usr/bin/python
# -*- coding: utf-8 -*-

import numpy as np
import matplotlib.pyplot as plt
import matplotlib
from scipy import ndimage

matplotlib.interactive(True)


def perceptron(X, y, max_iterations):
    """
    w, b = perceptron(X, y, max_iterations)

    Perceptron algorithm.
    Implements the perceptron algorithm
    (http://en.wikipedia.org/wiki/Perceptron)

    :param X:               d-dimensional observations, (d, number_of_observations) np array
    :param y:               labels of the observations (0 or 1), (n,) np array
    :param max_iterations:  number of algorithm iterations (scalar)
    :return w:              w - weights, (d,) np array
    :return b:              b - bias, python float
    """
    y = -(y.astype(np.int8) * 2 - 1)
    w = np.zeros(X.shape[0])
    b = 0

    step_size = .5

    success = False
    for t in range(max_iterations):
        success = True
        for i in range(X.shape[1]):
            d = np.dot(X[:, i], w) + b

            if d * y[i] <= 0:
                success = False
                w = w + (step_size * X[:, i] * y[i])
                b = b + (step_size * y[i])

                break

        # Solution is found, return
        if success:
            return w, b

    # Did not find solution in given number of iterations
    return np.NaN, np.NaN


def lift_dimension(X):
    """
    Z = lift_dimension(X)

    Lifts the dimensionality of the feature space from 2 to 5 dimensions

    :param X:   observations in the original space
                2-dimensional observations, (2, number_of_observations) np array
    :return Z:  observations in the lifted feature space, (5, number_of_observations) np array
    """
    Z = np.zeros((5, X.shape[1]))
    Z[:2, :] = X
    Z[2, :] = Z[0, :] ** 2
    Z[3, :] = Z[0, :] * Z[1, :]
    Z[4, :] = Z[1, :] ** 2
    return Z


def classif_quadrat_perc(tst, model):
    """
    K = classif_quadrat_perc(tst, model)

    Classifies test samples using the quadratic discriminative function

    :param tst:     2-dimensional observations, (2, n) np array
    :param model:   dictionary with the trained perceptron classifier (parameters of the discriminative function)
                        model['w'] - weights vector, np array (d, )
                        model['b'] - bias term, python float
    :return:        Y - classification result (contains either 0 or 1), (n,) np array
    """

    X = lift_dimension(tst)

    N = X.shape[1]
    Y = np.zeros(N)

    d = np.array([np.dot(X[:, i], model['w']) + model['b'] for i in range(N)])

    Y[d <= 0] = 1
    return Y


################################################################################
#####                                                                      #####
#####             Below this line are already prepared methods             #####
#####                                                                      #####
################################################################################

def pboundary(X, y, model, figsize=None, style_0='bx', style_1='r+'):
    """
    pboundary(X, y, model)

    Plot boundaries for perceptron decision strategy

    :param X:       d-dimensional observations, (d, number_of_observations) np array
    :param y:       labels of the observations (0 or 1), (n,) np array
    :param model:   dictionary with the trained perceptron classifier (parameters of the discriminative function)
                        model['w'] - weights vector, np array (d, )
                        model['b'] - bias term, python float
    """

    plt.figure(figsize=figsize)
    plt.plot(X[0, y == 0], X[1, y == 0], style_0, ms=10)
    plt.plot(X[0, y == 1], X[1, y == 1], style_1, ms=10)

    minx, maxx = plt.xlim()
    miny, maxy = plt.ylim()

    epsilon = 0.1 * np.maximum(np.abs(maxx - minx), np.abs(maxy - miny))

    x_space = np.linspace(minx - epsilon, maxx + epsilon, 1000)
    y_space = np.linspace(miny - epsilon, maxy + epsilon, 1000)
    x_grid, y_grid = np.meshgrid(x_space, y_space)

    x_grid_fl = x_grid.reshape([1, -1])
    y_grid_fl = y_grid.reshape([1, -1])

    X_grid = np.concatenate([x_grid_fl, y_grid_fl], axis=0)
    Y_grid = classif_quadrat_perc(X_grid, model)
    Y_grid = Y_grid.reshape([1000, 1000])

    blurred_Y_grid = ndimage.gaussian_filter(Y_grid, sigma=0)

    plt.contour(x_grid, y_grid, blurred_Y_grid, colors=['black'])
    plt.xlim(minx, maxx)
    plt.ylim(miny, maxy)


def main():
    # data = np.load("data_perceptron_separable.npz", allow_pickle=True)
    # X = data["X"]
    # y = data["y"]
    #
    # w, b = perceptron(X, y, 100)
    #
    # print('your solution may differs\nw: ', w, '\nb: ', b)

    X_un = np.array([[1, 1], [3, 3], [4, 4], [2, 2], [5, 5]], dtype=np.float32).T
    y_un = np.array([0, 1, 0, 1, 0])

    Z_un = lift_dimension(X_un)

    # Run the perceptron algorithm with at most 100 iterations
    w_un, b_un = perceptron(Z_un, y_un, 100)

    model = {'w': w_un, 'b': b_un}
    pboundary(X_un, y_un, model)

    plt.title('Perceptron algorithm in a lifted space')
    plt.savefig('perceptron_quadratic.png')


if __name__ == "__main__":
    main()
