#!/usr/bin/python
# -*- coding: utf-8 -*-

import numpy as np
import matplotlib.pyplot as plt
from numpy import ndarray


def logistic_loss(X, y, w):
    """
    E = logistic_loss(X, y, w)

    Evaluates the logistic loss function.

    :param X:    d-dimensional observations with X[0, :] == 1, np.array (d, n)
    :param y:    labels of the observations, np.array (n, )
    :param w:    weights, np.array (d, )
    :return E:   calculated loss, python float
    """
    N = y.size
    tmp = -y * X
    w = w.reshape((1, -1))
    exponent = np.matmul(w, tmp)
    E_x = np.log(1 + np.exp(exponent))
    E = (1 / N) * np.sum(E_x)
    return float(E)


def logistic_loss_gradient(X, y, w):
    """
    g = logistic_loss_gradient(X, y, w)

    Calculates gradient of the logistic loss function.

    :param X:   d-dimensional observations with X[0, :] == 1, np.array (d, n)
    :param y:   labels of the observations, np.array (n, )
    :param w:   weights, np.array (d, )
    :return g:  resulting gradient vector, np.array (d, )
    """
    N = y.size

    tmp = y * X
    w = w.reshape((1, -1))
    exponent = np.matmul(w, tmp)

    tmp2 = 1 / (1 + np.exp(exponent))
    tmp3 = tmp2 * tmp
    tmp_sum = np.sum(tmp3, 1)
    g = (-1 / N) * tmp_sum
    return g


def compute_Eg(X, y, w):
    g = logistic_loss_gradient(X, y, w)
    E = logistic_loss(X, y, w)

    return E, g


def compute_norm(x):
    x2 = x ** 2
    norm = np.sqrt(np.sum(x2))
    return norm


def logistic_loss_gradient_descent(X, y, w_init, epsilon):
    """
    w, wt, Et = logistic_loss_gradient_descent(X, y, w_init, epsilon)

    Performs gradient descent optimization of the logistic loss function.

    :param X:       d-dimensional observations with X[0, :] == 1, np.array (d, n)
    :param y:       labels of the observations, np.array (n, )
    :param w_init:  initial weights, np.array (d, )
    :param epsilon: parameter of termination condition: np.norm(w_new - w_prev) <= epsilon, python float
    :return w:      w - resulting weights, np.array (d, )
    :return wt:     wt - progress of weights, np.array (d, number_of_accepted_candidates)
    :return Et:     Et - progress of logistic loss, np.array (number_of_accepted_candidates, )
    """
    # Start of algorithm
    w = w_init
    w_last = np.inf * np.ones(w_init.shape)
    step_size = 1.0
    E, g = compute_Eg(X, y, w)

    Et = np.array([E])
    wt = np.array(w.reshape((-1, 1)))

    while True:
        E_new, g_new = compute_Eg(X, y, w - step_size * g)

        if E_new < E:
            w_last = np.copy(w)
            w -= step_size * g
            g = g_new
            E = E_new
            step_size *= 2

            Et = np.append(Et, E)
            wt = np.hstack((wt, w.reshape((-1, 1))))
        else:
            step_size /= 2

        if compute_norm(w - w_last) <= epsilon:
            break

    return w, wt, Et


def sigmoid(k, w, X):
    w = w.reshape((1, -1))
    exponent = -np.matmul(k * w, X)
    sig = 1 / (1 + np.exp(exponent))
    return sig


def classify_images(X, w):
    """
    y = classify_images(X, w)

    Classification by logistic regression.

    :param X:    d-dimensional observations with X[0, :] == 1, np.array (d, n)
    :param w:    weights, np.array (d, )
    :return y:   estimated labels of the observations, np.array (n, )
    """
    p1 = sigmoid(1, w, X)
    p2 = sigmoid(-1, w, X)

    y = np.ones(p1.shape).astype(np.int32)
    y[p1 <= p2] = -1
    y.shape = -1
    return y


def get_threshold(w):
    """
    thr = get_threshold(w)

    Returns the optimal decision threshold given the sigmoid parameters w (for 1D data).

    :param w:    weights, np.array (2, )
    :return:     calculated threshold (scalar)
    """

    thr = -w[0] / w[1]
    return thr


################################################################################
#####                                                                      #####
#####             Below this line are already prepared methods             #####
#####                                                                      #####
################################################################################

def plot_gradient_descent(X, y, loss_function, w, wt, Et, min_w=-10, max_w=10, n_points=20):
    """
    plot_gradient_descent(X, y, loss_function, w, wt, Et)

    Plots the progress of the gradient descent.

    :param X:               d-dimensional observations with X[0, :] == 1, np.array (d, n)
    :param y:               labels of the observations, np.array (n, )
    :param loss_function:   pointer to a logistic loss function
    :param w:               weights, np.array (d, )
    :param wt:              progress of weights, np.array (d, number_of_accepted_candidates)
    :param Et:              progress of logistic loss, np.array (number_of_accepted_candidates, )
    :return:
    """

    if X.shape[0] != 2:
        raise NotImplementedError('Only 2-d loss functions can be visualized using this method.')

    fig = plt.figure(figsize=(12, 10))
    ax = fig.gca()

    # Plot the gradient descent
    W1, W2 = np.meshgrid(np.linspace(min_w, max_w, n_points), np.linspace(min_w, max_w, n_points))
    L = np.zeros_like(W1)
    for i in range(n_points):
        for j in range(n_points):
            L[i, j] = loss_function(X, y, np.array([W1[i, j], W2[i, j]]))
    z_min, z_max = np.min(L), np.max(L)
    c = ax.pcolor(W1, W2, L, cmap='viridis', vmin=z_min, vmax=z_max, edgecolor='k')
    fig.colorbar(c, ax=ax)

    # Highlight the found minimum
    plt.plot([w[0]], w[1], 'rs', markersize=15, fillstyle='none')
    plt.plot(wt[0, :], wt[1, :], 'w.', markersize=15, linewidth=1)
    plt.plot(wt[0, :], wt[1, :], 'w-', markersize=15, linewidth=1)
    plt.xlim([min_w, max_w])
    plt.ylim([min_w, max_w])
    plt.xlabel('w_0')
    plt.ylabel('w_1')
    plt.title('Gradient descent')


def plot_aposteriori(X, y, w):
    """
    plot_aposteriori(X, y, w)

    :param X:    d-dimensional observations with X[0, :] == 1, np.array (d, n)
    :param y:    labels of the observations, np.array (n, )
    :param w:    weights, np.array (d, )
    """

    xA = X[:, y == 1]
    xC = X[:, y == -1]

    plot_range = np.linspace(np.min(X[1, :]) - 0.5, np.max(X[1, :]) + 0.5, 100)
    pAx = 1 / (1 + np.exp(-plot_range * w[1] - w[0]))
    pCx = 1 / (1 + np.exp(plot_range * w[1] + w[0]))

    thr = get_threshold(w)

    plt.figure()
    plt.plot(plot_range, pAx, 'b-', linewidth=2)
    plt.plot(plot_range, pCx, 'r-', linewidth=2)
    plt.plot(xA, np.zeros_like(xA), 'b+')
    plt.plot(xC, np.ones_like(xC), 'r+')
    plt.plot([thr, thr], [0, 1], 'k-')
    plt.legend(['p(A|x)', 'p(C|x)'])


def compute_measurements(imgs, norm_parameters=None):
    """
    x = compute_measurement(imgs [, norm_parameters])

    Compute measurement on images, subtract sum of right half from sum of
    left half.

    :param imgs:              input images, np array (h, w, n)
    :param norm_parameters:   norm_parameters['mean'] python float
                              norm_parameters['std']  python float
    :return x:                measurements, np array (n, )
    :return norm_parameters:  norm_parameters['mean'] python float
                              norm_parameters['std']  python float
    """

    width = imgs.shape[1]
    sum_rows = np.sum(imgs, dtype=np.float64, axis=0)

    left_half = np.sum(sum_rows[:int(width // 2), :], axis=0)
    right_half = np.sum(sum_rows[int(width // 2):, :], axis=0)
    x = left_half - right_half

    if norm_parameters is None:
        # If normalization parameters are not provided, compute it from data
        norm_parameters = {'mean': float(np.mean(x)), 'std': float(np.std(x))}

    x = (x - norm_parameters['mean']) / norm_parameters['std']

    return x, norm_parameters


def show_classification(test_images, labels, letters):
    """
    show_classification(test_images, labels, letters)

    create montages of images according to estimated labels

    :param test_images:     np.array (h, w, n)
    :param labels:          labels for input images np.array (n,)
    :param letters:         string with letters, e.g. 'CN'
    """

    def montage(images, colormap='gray'):
        """
        Show images in grid.

        :param images:      np.array (h, w, n)
        :param colormap:    numpy colormap
        """
        h, w, count = images.shape
        h_sq = np.int(np.ceil(np.sqrt(count)))
        w_sq = h_sq
        im_matrix = np.zeros((h_sq * h, w_sq * w))

        image_id = 0
        for j in range(h_sq):
            for k in range(w_sq):
                if image_id >= count:
                    break
                slice_w = j * h
                slice_h = k * w
                im_matrix[slice_h:slice_h + w, slice_w:slice_w + h] = images[:, :, image_id]
                image_id += 1
        plt.imshow(im_matrix, cmap=colormap)
        plt.axis('off')
        return im_matrix

    unique_labels = np.unique(labels).flatten()
    for i in range(len(letters)):
        imgs = test_images[:, :, labels == unique_labels[i]]
        subfig = plt.subplot(1, len(letters), i + 1)
        montage(imgs)
        plt.title(letters[i])


def show_mnist_classification(imgs, labels, imgs_shape=None):
    """
    function show_mnist_classification(imgs, labels)

    Shows results of MNIST digits classification.

    :param imgs:         flatten images - d-dimensional observations, np.array (height x width, n)
    :param labels:       labels for input images np.array (n,)
    :param imgs_shape:   image dimensions, np.array([height, width])
    :return:
    """

    if imgs_shape is None:
        imgs_shape = np.array([28, 28])

    n_images = imgs.shape[1]
    images = np.zeros([imgs_shape[0], imgs_shape[1], n_images])

    for i in range(n_images):
        images[:, :, i] = np.reshape(imgs[:, i], [imgs_shape[0], imgs_shape[1]])

    plt.figure(figsize=(20, 10))
    show_classification(images, labels, '01')


def main():
    # data = np.load("data_logreg.npz", allow_pickle=True)
    # tst = data["tst"].item()
    # trn = data["trn"].item()
    #
    # trn_data, norm_parameters = compute_measurements(trn['images'])
    #
    #
    # ones = np.ones(trn['labels'].size)
    # train_X = np.vstack((ones, trn_data))
    #
    #
    #
    loss = logistic_loss(np.array([[1, 1, 1], [1, 2, 3]]), np.array([1, -1, -1]), np.array([1.5, -0.5]))
    print(loss)

    gradient = logistic_loss_gradient(np.array([[1, 1, 1], [1, 2, 3]]), np.array([1, -1, -1]), np.array([1.5, -0.5]))
    print(gradient)

    w_init = np.array([1.75, 3.4])
    epsilon = 1e-2
    [w, wt, Et] = logistic_loss_gradient_descent(train_X, trn['labels'], w_init, epsilon)
    print('w: ', w, '\nwt: ', wt, '\nEt: ', Et)

    thr = get_threshold(np.array([1.5, -0.7]))
    print(thr)

    y = classify_images(np.array([[1, 1, 1, 1, 1, 1, 1], [0.5, 1, 1.5, 2, 2.5, 3, 3.5]]), np.array([1.5, -0.5]))
    print(y)

    # MNIST

    # data = np.load("mnist_trn.npz", allow_pickle=True)
    # X, y, imsize = data["X"], data["y"], data["imsize"]
    #
    # # Add x0 = 1 (for the bias term)
    # ones = np.ones(X.shape[1])
    # X = np.vstack((ones, X))
    # # Training - gradient descent of the logistic loss function
    #
    # np.random.seed(1)  # to get the same example outputs
    # w_init = np.random.rand(X.shape[0])
    # epsilon = 1e-2
    #
    # w, _, Et = logistic_loss_gradient_descent(X, y, w_init, epsilon)


if __name__ == "__main__":
    main()
