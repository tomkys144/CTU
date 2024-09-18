#!/usr/bin/python
# -*- coding: utf-8 -*-

import matplotlib.patches as patches
import matplotlib.pyplot as plt
import numpy as np
from scipy.stats import norm


def bayes_risk_discrete(discrete_A, discrete_B, W, q):
    """
    R = bayes_risk_discrete(discrete_A, discrete_B, W, q)

    Compute bayesian risk for a discrete strategy q

    :param discrete_A['Prob']:      pXk(x|A) given as a (n, ) np.array
    :param discrete_A['Prior']:     prior probability pK(A)
    :param discrete_B['Prob']:      pXk(x|B) given as a (n, ) np.array
    :param discrete_B['Prior']:     prior probability pK(B)
    :param W:                       cost function np.array (states, decisions)
                                    (nr. of states and decisions is fixed to 2)
    :param q:                       strategy - (n, ) np.array, values 0 or 1
    :return:                        bayesian risk - python float
    """
    pA = discrete_A['Prob'] * discrete_A['Prior']
    pB = discrete_B['Prob'] * discrete_B['Prior']

    WA = W[0, np.where(q == 0, 0, 1)]
    WB = W[1, np.where(q == 1, 1, 0)]

    R = np.sum(pA * WA) + np.sum(pB * WB)
    return float(R)


def find_strategy_discrete(discrete_A, discrete_B, W):
    """
    q = find_strategy_discrete(distribution1, distribution2, W)

    Find bayesian strategy for 2 discrete distributions.

    :param discrete_A['Prob']:      pXk(x|A) given as a (n, ) np.array
    :param discrete_A['Prior']:     prior probability pK(A)
    :param discrete_B['Prob']:      pXk(x|B) given as a (n, ) np.array
    :param discrete_B['Prior']:     prior probability pK(B)
    :param W:                       cost function np.array (states, decisions)
                                    (nr. of states and decisions is fixed to 2)
    :return:                        q - optimal strategy (n, ) np.array, values 0 or 1
    """

    q = np.zeros(discrete_A['Prob'].shape, dtype=int)

    pA = discrete_A['Prob'] * discrete_A['Prior']
    pB = discrete_B['Prob'] * discrete_B['Prior']
    A = pA * W[0, 1] + pB * W[1, 1]
    B = pA * W[0, 0] + pB * W[1, 0]
    q[B > A] = 1

    # q = []
    # for i in range(discrete_A['Prob'].shape[0]):
    #     R0 = bayes_risk_discrete({'Prob': discrete_A['Prob'][i], 'Prior': discrete_A['Prior']},
    #                              {'Prob': discrete_B['Prob'][i], 'Prior': discrete_B['Prior']}, W, np.array([0]))
    #     R1 = bayes_risk_discrete({'Prob': discrete_A['Prob'][i], 'Prior': discrete_A['Prior']},
    #                              {'Prob': discrete_B['Prob'][i], 'Prior': discrete_B['Prior']}, W, np.array([1]))
    #
    #     if R0 <= R1:
    #         q.append(0)
    #     elif R0 > R1:
    #         q.append(1)
    # q = np.array(q)
    #
    # match = q == q_new

    return q


def classify_discrete(measurements, q):
    """
    function label = classify_discrete(measurements, q)

    Classify discrete measurement using a strategy q.

    :param measurements:    test set discrete measurements, (n, ) np.array, values from <-10, 10>
    :param q:               strategy (21, ) np.array of 0 or 1
    :return:                image labels, (n, ) np.array of 0 or 1
    """

    idx = (measurements + 10).astype('int')
    label = np.array(q)[idx]

    return label


def classification_error(predictions, labels):
    """
    error = classification_error(predictions, labels)

    :param predictions: (n, ) np.array of values 0 or 1 - predicted labels
    :param labels:      (n, ) np.array of values 0 or 1 - ground truth labels
    :return:            error - classification error ~ a fraction of predictions being incorrect
                        python float in range <0, 1>
    """
    wrong = np.where(predictions == labels, 0, 1)
    error = float(wrong.sum() / predictions.size)
    return error


def find_strategy_2normal(distribution_A, distribution_B):
    """
    q = find_strategy_2normal(distribution_A, distribution_B)

    Find optimal bayesian strategy for 2 normal distributions and zero-one loss function.

    :param distribution_A:  parameters of the normal dist.
                            distribution_A['Mean'], distribution_A['Sigma'], distribution_A['Prior'] - python floats
    :param distribution_B:  the same as distribution_A

    :return q:              strategy dict
                               q['t1'], q['t2'] - decision thresholds - python floats
                               q['decision'] - (3, ) np.int32 np.array decisions for intervals (-inf, t1>, (t1, t2>, (t2, inf)
                               If there is only one threshold, q['t1'] should be equal to q['t2'] and the middle decision should be 0
                               If there is no threshold, q['t1'] and q['t2'] should be -/+ infinity and all the decision values should be the same (0 preferred)
    """

    s_A = distribution_A['Sigma']
    m_A = distribution_A['Mean']
    p_A = distribution_A['Prior']
    s_B = distribution_B['Sigma']
    m_B = distribution_B['Mean']
    p_B = distribution_B['Prior']

    q = {}

    # extreme priors
    eps = 1e-10
    if p_A < eps:
        q['t1'] = -np.inf
        q['t2'] = np.inf
        q['decision'] = np.array([1, 1, 1])
        print(q)
    elif p_B < eps:
        q['t1'] = -np.inf
        q['t2'] = np.inf
        q['decision'] = np.array([0, 0, 0])
        print(q)
    else:
        a = s_A ** 2 - s_B ** 2
        b = 2 * (s_B ** 2 * m_A - s_A ** 2 * m_B)
        c = (s_A ** 2 * m_B ** 2) - (s_B ** 2 * m_A ** 2) + (
                2 * s_A ** 2 * s_B ** 2 * np.log((p_A * s_B) / (p_B * s_A)))

        if a == 0:
            # same sigmas -> not quadratic
            if b == 0:
                # same sigmas and same means -> not even linear
                q['t1'] = -np.inf
                q['t2'] = np.inf
                if c >= 0:
                    q['decision'] = np.array([0, 0, 0])
                else:
                    q['decision'] = np.array([1, 1, 1])
            else:
                # same sigmas, different means -> linear equation
                q['t1'] = q['t2'] = (-c) / b
                if b > 0:
                    q['decision'] = np.array([1, 0, 0])
                else:
                    q['decision'] = np.array([0, 0, 1])
        else:
            # quadratic equation
            D = b ** 2 - (4 * a * c)

            if D > 0:
                th1 = (-b + np.sqrt(D)) / (2 * a)
                th2 = (-b - np.sqrt(D)) / (2 * a)
                if th1 < th2:
                    q['t1'] = th1
                    q['t2'] = th2
                else:
                    q['t1'] = th2
                    q['t2'] = th1
                if a > 0:
                    q['decision'] = np.array([0, 1, 0])
                else:
                    q['decision'] = np.array([1, 0, 1])
            elif D == 0:
                q['t1'] = q['t2'] = (-b) / (2 * a)
                if a > 0:
                    q['decision'] = np.array([0, 0, 0])
                else:
                    q['decision'] = np.array([1, 0, 1])
            elif D < 0:
                q['t1'] = -np.inf
                q['t2'] = np.inf
                if c >= 0:
                    q['decision'] = np.array([0, 0, 0])
                else:
                    q['decision'] = np.array([1, 1, 1])

    q['t1'] = float(q['t1'])
    q['t2'] = float(q['t2'])
    q['decision'] = q['decision'].astype(np.int32)
    return q


def bayes_risk_2normal(distribution_A, distribution_B, q):
    """
    R = bayes_risk_2normal(distribution_A, distribution_B, q)

    Compute bayesian risk of a strategy q for 2 normal distributions and zero-one loss function.

    :param distribution_A:  parameters of the normal dist.
                            distribution_A['Mean'], distribution_A['Sigma'], distribution_A['Prior'] python floats
    :param distribution_B:  the same as distribution_A
    :param q:               strategy
                               q['t1'], q['t2'] - float decision thresholds (python floats)
                               q['decision'] - (3, ) np.int32 np.array 0/1 decisions for intervals (-inf, t1>, (t1, t2>, (t2, inf)
    :return:    R - bayesian risk, python float
    """
    s_A = distribution_A['Sigma']
    m_A = distribution_A['Mean']
    p_A = distribution_A['Prior']
    s_B = distribution_B['Sigma']
    m_B = distribution_B['Mean']
    p_B = distribution_B['Prior']
    t1 = q['t1']
    t2 = q['t2']
    decision = q['decision']

    R = 1

    if decision[0] == 0:
        R -= p_A * norm.cdf(x=t1, loc=m_A, scale=s_A)
    else:
        R -= p_B * norm.cdf(x=t1, loc=m_B, scale=s_B)

    if decision[1] == 0:
        R -= p_A * (norm.cdf(x=t2, loc=m_A, scale=s_A) - norm.cdf(x=t1, loc=m_A, scale=s_A))
    else:
        R -= p_B * (norm.cdf(x=t2, loc=m_B, scale=s_B) - norm.cdf(x=t1, loc=m_B, scale=s_B))

    if decision[2] == 0:
        R -= p_A * (1 - norm.cdf(x=t2, loc=m_A, scale=s_A))
    else:
        R -= p_B * (1 - norm.cdf(x=t2, loc=m_B, scale=s_B))

    return float(R)


def classify_2normal(measurements, q):
    """
    label = classify_2normal(measurements, q)

    Classify images using continuous measurements and strategy q.

    :param imgs:    test set measurements, np.array (n, )
    :param q:       strategy
                    q['t1'] q['t2'] - float decision thresholds
                    q['decision'] - (3, ) int32 np.array decisions for intervals (-inf, t1>, (t1, t2>, (t2, inf)
    :return:        label - classification labels, (n, ) int32
    """
    t1 = q['t1']
    t2 = q['t2']
    decision = q['decision']
    measurements = measurements.astype(float)

    label = np.copy(measurements)
    label[measurements < t1] = decision[0]
    label[np.logical_and(measurements > t1, measurements < t2)] = decision[1]
    label[measurements > t2] = decision[2]
    label = label.astype(np.int32)
    return label


################################################################################
#####                                                                      #####
#####             Below this line are already prepared methods             #####
#####                                                                      #####
################################################################################


def compute_measurement_lr_cont(imgs):
    """
    x = compute_measurement_lr_cont(imgs)

    Compute measurement on images, subtract sum of right half from sum of
    left half.

    :param imgs:    set of images, (h, w, n)
    :return:        measurements, (n, )
    """
    assert len(imgs.shape) == 3

    width = imgs.shape[1]
    sum_rows = np.sum(imgs, dtype=np.float64, axis=0)

    x = np.sum(sum_rows[0:int(width / 2), :], axis=0) - np.sum(sum_rows[int(width / 2):, :], axis=0)

    assert x.shape == (imgs.shape[2],)
    return x


def visualize_discrete(discrete_A, discrete_B, q):
    """
    visualize_discrete(discrete_A, discrete_B, q)

    Visualize a strategy for 2 discrete distributions.

    :param discrete_A['Prob']:      pXk(x|A) given as a (n, ) np.array
    :param discrete_A['Prior']:     prior probability pK(A)
    :param discrete_B['Prob']:      pXk(x|B) given as a (n, ) np.array
    :param discrete_B['Prior']:     prior probability pK(B)
    :param q:                       strategy - (n, ) np.array, values 0 or 1
    """

    posterior_A = discrete_A['Prob'] * discrete_A['Prior']
    posterior_B = discrete_B['Prob'] * discrete_B['Prior']

    max_prob = np.max([posterior_A, posterior_B])

    fig = plt.figure()
    ax = fig.add_subplot(111)
    plt.title("Posterior probabilities and strategy q")
    plt.xlabel("feature")
    plt.ylabel("posterior probabilities")

    bins = np.array(range(posterior_A.size + 1)) - int(posterior_A.size / 2)

    width = 0.75
    bar_plot_A = plt.bar(bins[:-1], posterior_A, width=width, color='b', alpha=0.75)
    bar_plot_B = plt.bar(bins[:-1], posterior_B, width=width, color='r', alpha=0.75)

    plt.legend((bar_plot_A, bar_plot_B), (r'$p_{XK}(x,A)$', r'$p_{XK}(x,B)$'))

    sub_level = - max_prob / 8
    height = np.abs(sub_level)
    for idx in range(len(bins[:-1])):
        b = bins[idx]
        col = 'r' if q[idx] == 1 else 'b'
        patch = patches.Rectangle([b - 0.5, sub_level], 1, height, angle=0.0, color=col, alpha=0.75)
        ax.add_patch(patch)

    plt.ylim(bottom=sub_level)
    plt.text(bins[0], -max_prob / 16, 'strategy q')


def visualize_2norm(cont_A, cont_B, q):
    n_sigmas = 5
    n_points = 200

    A_range = (cont_A['Mean'] - n_sigmas * cont_A['Sigma'],
               cont_A['Mean'] + n_sigmas * cont_A['Sigma'])
    B_range = (cont_B['Mean'] - n_sigmas * cont_B['Sigma'],
               cont_B['Mean'] + n_sigmas * cont_B['Sigma'])
    start = min(A_range[0], B_range[0])
    stop = max(A_range[1], B_range[1])

    xs = np.linspace(start, stop, n_points)
    A_vals = cont_A['Prior'] * norm.pdf(xs, cont_A['Mean'], cont_A['Sigma'])
    B_vals = cont_B['Prior'] * norm.pdf(xs, cont_B['Mean'], cont_B['Sigma'])

    colors = ['r', 'b']
    plt.plot(xs, A_vals, c=colors[0], label='A')
    plt.plot(xs, B_vals, c=colors[1], label='B')

    plt.axvline(x=q['t1'], c='k', lw=0.5, ls=':')
    plt.axvline(x=q['t2'], c='k', lw=0.5, ls=':')

    offset = 0.000007
    sub_level = -0.000025
    left = xs[0]
    right = xs[-1]

    def clip(x, lb, ub):
        res = x
        if res < lb:
            res = lb
        if res > ub:
            res = ub
        return res

    t1 = clip(q['t1'], xs[0], xs[-1])
    t2 = clip(q['t2'], xs[0], xs[-1])

    patch = patches.Rectangle([left, sub_level], t1 - left, -sub_level - offset, angle=0.0,
                              color=colors[q['decision'][0]], alpha=0.75)
    plt.gca().add_patch(patch)
    patch = patches.Rectangle([t1, sub_level], t2 - t1, -sub_level - offset, angle=0.0,
                              color=colors[q['decision'][1]], alpha=0.75)
    plt.gca().add_patch(patch)
    patch = patches.Rectangle([t2, sub_level], right - t2, -sub_level - offset, angle=0.0,
                              color=colors[q['decision'][2]], alpha=0.75)
    plt.gca().add_patch(patch)
    plt.legend()

    plt.title("Posterior probabilities and strategy q")
    plt.xlabel("image LR feature")
    plt.ylabel("posterior probabilities")


def compute_measurement_lr_discrete(imgs):
    """
    x = compute_measurement_lr_discrete(imgs)

    Calculates difference between left and right half of image(s).

    :param imgs:    set of images, (h, w, n) (or for color images (h, w, 3, n)) np.array
    :return:        (n, ) np.array of values in range <-10, 10>,
    """
    assert len(imgs.shape) in (3, 4)
    assert (imgs.shape[2] == 3 or len(imgs.shape) == 3)

    mu = -563.9
    sigma = 2001.6

    if len(imgs.shape) == 3:
        imgs = np.expand_dims(imgs, axis=2)

    imgs = imgs.astype(np.int32)
    height, width, channels, count = imgs.shape

    x_raw = np.sum(np.sum(np.sum(imgs[:, 0:int(width / 2), :, :], axis=0), axis=0), axis=0) - \
            np.sum(np.sum(np.sum(imgs[:, int(width / 2):, :, :], axis=0), axis=0), axis=0)
    x_raw = np.squeeze(x_raw)

    x = np.atleast_1d(np.round((x_raw - mu) / (2 * sigma) * 10))
    x[x > 10] = 10
    x[x < -10] = -10

    assert x.shape == (imgs.shape[-1],)
    return x


def montage(images, colormap='gray'):
    """
    Show images in grid.

    :param images:  np.array (h, w, n)
    """
    h, w, count = np.shape(images)
    h_sq = np.int(np.ceil(np.sqrt(count)))
    w_sq = h_sq
    im_matrix = np.zeros((h_sq * h, w_sq * w))

    image_id = 0
    for k in range(w_sq):
        for j in range(h_sq):
            if image_id >= count:
                break
            slice_w = j * h
            slice_h = k * w
            im_matrix[slice_h:slice_h + w, slice_w:slice_w + h] = images[:, :, image_id]
            image_id += 1
    plt.imshow(im_matrix, cmap=colormap)
    plt.axis('off')
    return im_matrix


################################################################################
#####                                                                      #####
#####             Below this line you may insert debugging code            #####
#####                                                                      #####
################################################################################

def main():
    # HERE IT IS POSSIBLE TO ADD YOUR TESTING OR DEBUGGING CODE
    data = np.load("data_33rpz_bayes.npz", allow_pickle=True)
    alphabet = data["alphabet"]
    images_test = data["images_test"]
    labels_test = data["labels_test"]
    contA = {'Mean': 124.2625,
             'Sigma': 1434.45420083,
             'Prior': 0.61538462}
    contC = {'Mean': -2010.98,
             'Sigma': 558.42857106,
             'Prior': 0.38461538}

    q_cont = find_strategy_2normal(contA, contC)
    print(q_cont)

    measurements_cont = compute_measurement_lr_cont(images_test)
    labels_estimated_cont = classify_2normal(measurements_cont, q_cont)
    error_cont = classification_error(labels_estimated_cont, labels_test)
    print('Continuous classification error: {}'.format(error_cont))

    R_cont = bayes_risk_2normal(contA, contC, q_cont)
    print('Bayes risk: {}'.format(R_cont))


if __name__ == "__main__":
    main()
