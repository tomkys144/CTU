#!/usr/bin/python
# -*- coding: utf-8 -*-

import itertools

import matplotlib.pyplot as plt
import numpy as np


def k_means(x, k, max_iter, show=False, init_means=None):
    """
    Implementation of the k-means clustering algorithm.

    :param x:               feature vectors, np array (dim, number_of_vectors)
    :param k:               required number of clusters, scalar
    :param max_iter:        stopping criterion: max. number of iterations
    :param show:            (optional) boolean switch to turn on/off visualization of partial results
    :param init_means:      (optional) initial cluster prototypes, np array (dim, k)

    :return cluster_labels: cluster index for each feature vector, np array (number_of_vectors, )
                            array contains only values from 0 to k-1,
                            i.e. cluster_labels[i] is the index of a cluster which the vector x[:,i] belongs to.
    :return centroids:      cluster centroids, np array (dim, k), same type as x
                            i.e. centroids[:,i] is the center of the i-th cluster.
    :return sq_dists:       squared distances to the nearest centroid for each feature vector,
                            np array (number_of_vectors, )

    Note 1: The iterative procedure terminates if either maximum number of iterations is reached
            or there is no change in assignment of data to the clusters.

    Note 2: DO NOT MODIFY INITIALIZATIONS

    """
    if max_iter < 1:
        raise AttributeError("max_iter cannot be lower than one!")

    # Number of vectors
    n_vectors = x.shape[1]
    cluster_labels = np.zeros([n_vectors], np.int32)

    # Means initialization
    if init_means is None:
        ind = np.random.choice(n_vectors, k, replace=False)
        centroids = x[:, ind]
    else:
        centroids = init_means

    i_iter = 0
    while i_iter < max_iter:
        centroids_i = np.copy(centroids)
        dists = np.zeros((n_vectors, k))

        for k_i in range(k):
            diff = np.subtract(np.copy(x).T, centroids[:, k_i])
            dists[:, k_i] = np.square(np.linalg.norm(diff, axis=1))

        cluster_labels = np.argmin(dists, axis=1)

        for k_i in range(k):
            mean = np.mean(x[:, cluster_labels == k_i], axis=1)
            centroids[:, k_i] = mean
        # Ploting partial results
        if show:
            print('Iteration: {:d}'.format(i_iter))
            show_clusters(x, cluster_labels, centroids, title='Iteration: {:d}'.format(i_iter))

        if np.array_equal(centroids, centroids_i):
            break

        i_iter += 1

    sq_dists = dists[np.arange(len(dists)), cluster_labels]

    if show:
        print('Done.')

    return cluster_labels, centroids, sq_dists


def k_means_multiple_trials(x, k, n_trials, max_iter, show=False):
    """
    Performs several trials of the k-centroids clustering algorithm in order to
    avoid local minima. Result of the trial with the lowest "within-cluster
    sum of squares" is selected as the best one and returned.

    :param x:               feature vectors, np array (dim, number_of_vectors)
    :param k:               required number of clusters, scalar
    :param n_trials:        number of trials, scalars
    :param max_iter:        stopping criterion: max. number of iterations
    :param show:            (optional) boolean switch to turn on/off visualization of partial results

    :return cluster_labels: cluster index for each feature vector, np array (number_of_vectors, ),
                            array contains only values from 0 to k-1,
                            i.e. cluster_labels[i] is the index of a cluster which the vector x[:,i] belongs to.
    :return centroids:      cluster centroids, np array (dim, k), same type as x
                            i.e. centroids[:,i] is the center of the i-th cluster.
    :return sq_dists:       squared distances to the nearest centroid for each feature vector,
                            np array (number_of_vectors, )
    """
    cluster_labels, centroids, sq_dists = np.array([]), np.array([]), np.array([])
    for n in range(n_trials):
        cluster_labels_n, centroids_n, sq_dists_n = k_means(x, k, max_iter, show)
        if (sq_dists_n.sum() < sq_dists.sum()) or (sq_dists.size == 0):
            cluster_labels = np.copy(cluster_labels_n)
            centroids = np.copy(centroids_n)
            sq_dists = np.copy(sq_dists_n)

    return cluster_labels, centroids, sq_dists


def random_sample(weights):
    """
    picks randomly a sample based on the sample weights.

    :param weights: array of sample weights, np array (n, )
    :return idx:    index of chosen sample, scalar

    Note: use np.random.uniform() for random number generation in open interval (0, 1)
    """
    weights_norm = weights / weights.sum()

    weight = np.random.random_sample()

    idx_weights = np.cumsum(weights_norm)

    idx = np.argmax(idx_weights > weight)
    return idx


def k_meanspp(x, k):
    """
    performs k-means++ initialization for k-means clustering.

    :param x:           Feature vectors, np array (dim, number_of_vectors)
    :param k:           Required number of clusters, scalar

    :return centroids:  proposed centroids for k-means initialization, np array (dim, k)
    """
    [dim, n_vectors] = x.shape
    centroids = np.zeros((dim, k))

    c_1_idx = np.random.uniform(low=0, high=n_vectors, size=None)
    c_1_idx = int(c_1_idx)
    centroids[:, 0] = x[:, c_1_idx].reshape((-1))

    for k_i in range(1, k):
        dists = np.zeros((n_vectors, k_i))
        for k_i_i in range(k_i):
            diff = np.subtract(np.copy(x).T, centroids[:, k_i_i])
            dists[:, k_i_i] = np.linalg.norm(diff, axis=1)
        dist_l = dists.min(axis=1)
        dist_l_2 = dist_l ** 2

        dist_l_2_sum = dist_l_2.sum()
        p_l = dist_l_2 / dist_l_2_sum

        idx = random_sample(p_l)

        centroids[:, k_i] = x[:, idx].reshape((-1))

    return centroids


def quantize_colors(im, k):
    """
    Image color quantization using the k-means clustering. A subset of 1000 pixels
    is first clustered into k clusters based on their RGB color.
    Quantized image is constructed by replacing each pixel color by its cluster centroid.

    :param im:          image for quantization, np array (h, w, 3) (np.uint8)
    :param k:           required number of quantized colors, scalar
    :return im_q:       image with quantized colors, np array (h, w, 3) (uint8)
    
    note: make sure that the k-means is run on floating point inputs.
    """
    N = im.shape[0]*im.shape[1]
    im_prepared = im.reshape((N, 3)).astype(np.float64).T
    inds = np.random.randint(0, N-1, 1000)
    x_trn = im_prepared[:, inds]
    cluster_labels, centroids, sq_dists = k_means(x_trn, k, max_iter=float('inf'))
    dists = np.zeros((N, k))
    for k_i in range(k):
        diff = np.subtract(np.copy(im_prepared).T, centroids[:, k_i])
        dists[:, k_i] = np.square(np.linalg.norm(diff, axis=1))

    labels = np.argmin(dists, axis=1)

    im_prepared_q = centroids[:, labels].T
    im_q = im_prepared_q.reshape(im.shape).astype(np.uint8)
    return im_q


################################################################################
#####                                                                      #####
#####             Below this line are already prepared methods             #####
#####                                                                      #####
################################################################################


def compute_measurements(images):
    """
    computes 2D features from image measurements

    :param images: array of images, np array (H, W, N_images) (np.uint8)
    :return x:     array of features, np array (2, N_images)
    """

    images = images.astype(np.float64)
    H, W, N = images.shape

    left = images[:, :(W // 2), :]
    right = images[:, (W // 2):, :]
    up = images[:(H // 2), ...]
    down = images[(H // 2):, ...]

    L = np.sum(left, axis=(0, 1))
    R = np.sum(right, axis=(0, 1))
    U = np.sum(up, axis=(0, 1))
    D = np.sum(down, axis=(0, 1))

    a = L - R
    b = U - D

    x = np.vstack((a, b))
    return x


def show_clusters(x, cluster_labels, centroids, title=None):
    """
    Create plot of feature vectors with same colour for members of same cluster.

    :param x:               feature vectors, np array (dim, number_of_vectors) (float64/double),
                            where dim is arbitrary feature vector dimension
    :param cluster_labels:  cluster index for each feature vector, np array (number_of_vectors, ),
                            array contains only values from 1 to k,
                            i.e. cluster_labels[i] is the index of a cluster which the vector x[:,i] belongs to.
    :param centroids:       cluster centers, np array (dim, k) (float64/double),
                            i.e. centroids[:,i] is the center of the i-th cluster.
    """

    cluster_labels = cluster_labels.flatten()
    clusters = np.unique(cluster_labels)
    markers = itertools.cycle(['*', 'o', '+', 'x', 'v', '^', '<', '>'])

    plt.figure(figsize=(8, 7))
    for i in clusters:
        cluster_x = x[:, cluster_labels == i]
        # print(cluster_x)
        plt.plot(cluster_x[0], cluster_x[1], next(markers))
    plt.axis('equal')

    len = centroids.shape[1]
    for i in range(len):
        plt.plot(centroids[0, i], centroids[1, i], 'm+', ms=10, mew=2)

    plt.axis('equal')
    plt.grid('on')
    if title is not None:
        plt.title(title)


def show_clustered_images(images, labels, title=None):
    """
    Shows results of clustering. Create montages of images according to estimated labels

    :param images:          input images, np array (h, w, n)
    :param labels:          labels of input images, np array (n, )
    """
    assert (len(images.shape) == 3)

    labels = labels.flatten()
    l = np.unique(labels)
    n = len(l)

    def montage(images, colormap='gray'):
        h, w, count = np.shape(images)
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

    fig = plt.figure(figsize=(10, 10))
    ww = int(np.ceil(float(n) / np.sqrt(n)))
    hh = int(np.ceil(float(n) / ww))

    for i in range(n):
        imgs = images[:, :, labels == unique_labels[i]]
        subfig = plt.subplot(hh, ww, i + 1)
        montage(imgs)

    if title is not None:
        fig.suptitle(title)


def show_mean_images(images, labels, letters=None, title=None):
    """
    show_mean_images(images, c)

    Compute mean image for a cluster and show it.

    :param images:          input images, np array (h, w, n)
    :param labels:          labels of input images, np array (n, )
    :param letters:         labels for mean images, string/array of chars
    """
    assert (len(images.shape) == 3)

    labels = labels.flatten()
    l = np.unique(labels)
    n = len(l)

    unique_labels = np.unique(labels).flatten()

    fig = plt.figure()
    ww = int(np.ceil(float(n) / np.sqrt(n)))
    hh = int(np.ceil(float(n) / ww))

    for i in range(n):
        imgs = images[:, :, labels == unique_labels[i]]
        img_average = np.squeeze(np.average(imgs.astype(np.float64), axis=2))
        subfig = plt.subplot(hh, ww, i + 1)
        plt.imshow(img_average, cmap='gray')
        if letters is not None:
            plt.title(letters[i])
        plt.axis('off')

    if title is not None:
        fig.suptitle(title)


def gen_kmeanspp_data(mu=None, sigma=None, n=None):
    """
    generates data with n_clusterss normally distributed clusters

    It generates 4 clusters with 80 points by default.

    :param mu:          mean of normal distribution, np array (dim, n_clusters)
    :param sigma:       std of normal distribution, scalar
    :param n:           number of output points for each distribution, scalar
    :return samples:    dim-dimensional samples with n samples per cluster, np array (dim, n_clusters * n)
    """

    sigma = 1. if sigma is None else sigma
    mu = np.array([[-5, 0], [5, 0], [0, -5], [0, 5]]) if mu is None else mu
    n = 80 if n is None else n

    samples = np.random.normal(np.tile(mu, (n, 1)).T, sigma)
    return samples


def main():
    np.random.seed(0)

    # x = np.array([[16, 12, 50, 96, 34, 59, 22, 75, 26, 51]])
    # cluster_labels, centroids, sq_dists = k_means(x, 3, np.inf)
    # print('cluster_labels: ', cluster_labels, '\ncentroids: ', centroids, '\nsq_dists: ', sq_dists)
    #
    # images = np.load("data_kmeans.npz", allow_pickle=True)["images"]
    # x = compute_measurements(images)
    # _, centroids, _ = k_means(x, 3, 4)
    # print('centroids:\n', centroids)

    # distances = np.array([10, 2, 4, 8, 3])
    # idx_1 = random_sample(distances)
    # idx_2 = random_sample(distances)
    # print('idx_1: ', idx_1, '\nidx_2: ', idx_2)

    np.random.seed(0)
    x = np.atleast_2d(np.array(range(100)))
    centroids = k_meanspp(np.vstack((x, x)), 3)
    print('centroids: ', centroids)

    # im = (plt.imread('geeks.png') * 255).astype(np.uint8)
    # plt.imshow(im)
    # plt.axis('off')
    # plt.title('RPZ instructors when they were young')
    #
    # np.random.seed(0)
    # im_q = quantize_colors(im, 8)
    #
    # plt.figure()
    # plt.imshow(im_q)
    # plt.axis('off')
    # plt.title('Quantized image')
    # plt.savefig('geeks_quantized.png')


if __name__ == "__main__":
    main()
