import matplotlib.pyplot as plt
import numpy as np


def adaboost(X, y, num_steps):
    """
    Trains an AdaBoost classifier

    :param X:                   training data containing feature points in columns, np array (d, n)
                                    d - number of weak classifiers
                                    n - number of data
    :param y:                   vector with labels (-1, 1) for feature points in X, np array (n, )
    :param num_steps:           maximum number of iterations

    :return strong_classifier:  dict with fields:
        - strong_classifier['wc'] - weak classifiers (see docstring of find_best_weak), np array (n_wc, )
        - strong_classifier['alpha'] - weak classifier coefficients, np array (n_wc, )
    :return wc_errors:          error of the best weak classifier in each iteration, np array (n_wc, )
    :return upper_bound:        upper bound on the training error in each iteration, np array (n_wc, )
    """
    N = X.shape[1]

    alpha = []
    wc = []
    wc_errors = []
    upper_bound = []
    Z = []

    Dt = np.ones((N,))
    Dt[y == 1] = (1 / 2) / np.sum(y == 1)
    Dt[y == -1] = (1 / 2) / np.sum(y == -1)
    D = [np.copy(Dt)]

    for t in range(num_steps):
        h_t, e_t = find_best_weak(X, y, Dt)

        wc.append(h_t)
        wc_errors.append(e_t)

        if e_t > 0.5:
            break

        a_t = np.log((1 - e_t) / e_t) / 2
        alpha.append(a_t)

        htx = np.sign(h_t['parity'] * (X[h_t['idx'], :] - h_t['theta']))

        Dt = np.copy(D[t])
        Dt[y == htx] = 0.5 * Dt[y == htx] / (1 - e_t)
        Dt[y != htx] = 0.5 * Dt[y != htx] / e_t
        D.append(np.copy(Dt))

        Z.append(2 * np.sqrt(e_t * (1 - e_t)))

        upper_bound.append(np.prod(np.array(Z)))

    strong_classifier = {
        'wc': np.array(wc),
        'alpha': np.array(alpha)
    }

    return strong_classifier, np.array(wc_errors), np.array(upper_bound)


def adaboost_classify(strong_classifier, X):
    """ Classifies data X with a strong classifier

    :param strong_classifier:   classifier returned by adaboost (see docstring of adaboost)
    :param X:                   testing data containing feature points in columns, np array (d, n)
                                    d - number of weak classifiers
                                    n - number of data
    :return classif:            classification labels (values -1, 1), np array (n, )
    """
    T = strong_classifier['alpha'].size
    Fx = np.zeros((X.shape[1],))

    for t in range(T):
        h_t = strong_classifier['wc'][t]
        a_t = strong_classifier['alpha'][t]

        htx = np.sign(h_t['parity'] * (X[h_t['idx'], :] - h_t['theta']))
        Fx += a_t * htx

    classif = np.sign(Fx)
    return classif


def compute_error(strong_classifier, X, y):
    """
    Computes the error on data X for all lengths of the given strong classifier

    :param strong_classifier:   classifier returned by adaboost - with T weak classifiers (see docstring of adaboost)
    :param X:                   testing data containing feature points in columns, np array (d, n)
                                    d - number of weak classifiers
                                    n - number of data
    :param y:                   testing labels (-1 or 1), np array (n, )
    :return errors:             errors of the strong classifier for all lengths from 1 to T, np array (T, )
    """
    T = strong_classifier['alpha'].size
    N = y.size

    errors = np.inf * np.ones((T,))

    for t in range(T):
        strong_classifier_t = {
            'wc': strong_classifier['wc'][:t + 1],
            'alpha': strong_classifier['alpha'][:t + 1]
        }

        y_classif_t = adaboost_classify(strong_classifier_t, X)

        diff_t = y_classif_t != y
        errors[t] = np.sum(diff_t) / N

    return errors


################################################################################
#####                                                                      #####
#####             Below this line are already prepared methods             #####
#####                                                                      #####
################################################################################


def find_best_weak(X, y, D):
    """Finds the best weak classifier

    Searches over all weak classifiers and their parametrisation
    (threshold and parity) for the weak classifier with the lowest
    weighted classification error.

    The weak classifier realises following classification function:
        sign(parity * (x - theta))

    :param X:           training data containing feature points in columns, np array (d, n)
                            d - number of weak classifiers
                            n - number of data
    :param y:           vector with labels (-1, 1) for feature points in X, np array (n, )
    :param D:           training data weights, np array (n, )

    :return wc:         dict representing weak classifier with following fields:
        - wc['idx'] - index of the selected weak classifier, scalar
        - wc['theta'] - the classification threshold, scalar
        - wc['parity'] - the classification parity, scalar
    :return wc_error:   the weighted error of the selected weak classifier
    """
    assert X.ndim == 2
    assert y.ndim == 1
    assert y.size == X.shape[1]
    assert D.ndim == 1
    assert D.size == X.shape[1]

    N_wc, N = X.shape
    best_err = np.inf
    wc = {}

    for i in range(N_wc):
        weak_X = X[i, :]  # weak classifier evaluated on all data

        thresholds = np.unique(weak_X)
        assert thresholds.ndim == 1

        if thresholds.size > 1:
            thresholds = (thresholds[:-1] + thresholds[1:]) / 2.
        else:
            thresholds = np.array([+1, -1] + thresholds[0])
        assert thresholds.ndim == 1

        K = thresholds.size

        classif = np.sign(np.reshape(weak_X, (N, 1)) - np.reshape(thresholds, (1, K)))
        assert classif.ndim == 2
        assert classif.shape[0] == N
        assert classif.shape[1] == K

        # Broadcast
        column_D = np.reshape(D, (N, 1))
        column_y = np.reshape(y, (N, 1))
        err_pos = np.sum(column_D * (classif != column_y), axis=0)
        err_neg = np.sum(column_D * (-classif != column_y), axis=0)

        assert err_pos.ndim == 1
        assert err_pos.shape[0] == K
        assert err_neg.ndim == 1
        assert err_neg.shape[0] == K

        min_pos_idx = np.argmin(err_pos)
        min_pos_err = err_pos[min_pos_idx]

        min_neg_idx = np.argmin(err_neg)
        min_neg_err = err_neg[min_neg_idx]

        if min_pos_err < min_neg_err:
            err = min_pos_err
            parity = 1
            theta = thresholds[min_pos_idx]
        else:
            err = min_neg_err
            parity = -1
            theta = thresholds[min_neg_idx]

        if err < best_err:
            wc['idx'] = i
            wc['theta'] = theta
            wc['parity'] = parity
            best_err = err
    return wc, best_err


def show_classification(test_images, labels):
    """
    show_classification(test_images, labels, letters)

    create montages of images according to estimated labels

    :param test_images:     np array (h, w, n)
    :param labels:          labels for input images np array (n,)
    """

    def montage(images, colormap='gray'):
        """
        Show images in grid.

        :param images:      np array (h, w, n)
        :param colormap:    numpy colormap
        """
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

    imgs = test_images[..., labels == 1]
    subfig = plt.subplot(1, 2, 1)
    montage(imgs)
    plt.title('selected')

    imgs = test_images[..., labels == -1]
    subfig = plt.subplot(1, 2, 2)
    montage(imgs)
    plt.title('others')


def show_classifiers(class_images, classifier):
    """
    :param class_images:  images of a selected number, np array (h, w, n)
    :param classifier:    adaboost classifier
    """
    assert len(class_images.shape) == 3
    mean_image = np.mean(class_images, axis=2)
    mean_image = np.dstack((mean_image, mean_image, mean_image))
    vis = np.reshape(mean_image, (-1, 3))
    max_alpha = np.amax(classifier['alpha'])

    for i, wc in enumerate(classifier['wc']):
        c = classifier['alpha'][i] / float(max_alpha)
        if wc['parity'] == 1:
            color = (c, 0, 0)
        else:
            color = (0, c, 0)
        vis[wc['idx'], :] = color

    vis = np.reshape(vis, mean_image.shape)
    plt.imshow(vis)
    plt.axis('off')


def main():
    X = np.array([[1, 1.5, 2.5, 3.0, 3.5, 5, 5.5, 6, 7., 8], [1, 4, 2, 8, 1, 4, 3, 5, 7, 11]])
    y = np.array([1, -1, 1, -1, 1, -1, 1, -1, 1, -1])
    strong_classifier, wc_error, upper_bound = adaboost(X, y, 3)
    # print('strong_classifier: ', strong_classifier, '\nwc_error: ', wc_error, '\nupper_bound: ', upper_bound)

    classif = adaboost_classify(strong_classifier, X)

    trn_errors = compute_error(strong_classifier, X, y)
    print('trn_error: ', trn_errors)


if __name__ == "__main__":
    main()
