#!/usr/bin/python
# -*- coding: utf-8 -*-

from bayes import *

from scipy.stats import multivariate_normal
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.patches as patches


def find_strategy_3normal(dist1, dist2, dist3):
    """
    Find optimal bayesian strategy for 3 normal distributions and zero-one loss function.

    :param dist1 parameters of the normal dist.
                            dist['Mean'], dist['Prior'] - python floats
                            dist['Cov'] - np.array(2,2, dtype=float)

    :param dist2:  the same as dist1

    :param dist3:  the same as dist1

    :return q strategy dict
    """
    k = dist1['Cov'].shape[0]

    if (dist2['Cov'].shape != (k, k)) or (dist3['Cov'].shape != (k,k)):
        raise ValueError("Covs are not all kxk!")

    


def main():
    D1 = {'Mean': np.array([151.61, 1154.01]),
          'Prior': 0.4166666666666667,
          'Cov': np.array([[2048960.78575758, 169829.10494949],
                           [169829.10494949, 482516.97969697]])}

    D2 = {'Mean': np.array([-2055.76666667, 54.3]),
          'Prior': 0.25,
          'Cov': np.array([[307539.97853107, -2813.69830508],
                           [-2813.69830508, 485574.58644068]])}

    D3 = {'Mean': np.array([492.7125, -2353.1125]),
          'Prior': 0.3333333333333333,
          'Cov': np.array([[968935.42262658, 12248.03053797],
                           [12248.03053797, 407017.16439873]])}

    find_strategy_normal(D1,D2,D3)

if __name__ == "__main__":
    main()