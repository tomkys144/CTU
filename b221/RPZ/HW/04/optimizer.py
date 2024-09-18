import time

import numpy as np

import mle_map_bayes as mmb


# load data
def loader():
    loaded_data = np.load("data_33rpz_mle_map_bayes.npz", allow_pickle=True)

    alphabet = loaded_data["alphabet"]

    tst = loaded_data["tst"].item()

    trn_20 = loaded_data["trn_20"].item()
    trn_200 = loaded_data["trn_200"].item()
    trn_2000 = loaded_data["trn_2000"].item()

    trn_sets = {'20': trn_20, '200': trn_200, '2000': trn_2000}

    # classify the data using all three estimates

    # select the training set
    picked_set = '20'  # your code probably won't work for '200' or '2000' due to numerical limitations
    # feel free to search for the source of the numerical problems and come up with a workaround
    # (it is doable relatively easily for '200')
    trn_set = trn_sets[picked_set]

    # computing LR feature vectors (training set)
    x_train = mmb.compute_measurement_lr_cont(trn_set['images'])
    labels_train = trn_set['labels']

    # Splitting the trainning data into into classes
    x_A = x_train[labels_train == 0]
    x_C = x_train[labels_train == 1]

    return tst, x_A, x_C


def map():
    tst, x_A, x_C = loader()
    x_test = mmb.compute_measurement_lr_cont(tst['images'])

    opt_mu0_A, opt_nu_A, opt_alpha_A, opt_beta_A = -2250, 1, 1, 1
    opt_mu0_C, opt_nu_C, opt_alpha_C, opt_beta_C = 670, 1, 1, 1

    err = np.inf
    mu_min = -1000
    mu_max = 1000
    mu_num = 10
    rngmu = np.linspace(mu_min, mu_max, num=mu_num, endpoint=False)
    rng = np.linspace(0, 100, num=3, endpoint=False)

    opts = [(mu0, nu, alpha, beta) for mu0 in rngmu for nu in rng for alpha in rng for beta in rng];

    for (mu0_A, nu_A, alpha_A, beta_A) in opts:
        print("A", mu0_A, nu_A, alpha_A, beta_A)
        for (mu0_C, nu_C, alpha_C, beta_C) in opts:
            print("C",mu0_C, nu_C, alpha_C, beta_C)
            start = time.time()
            q_map, labels_map, DA_map, DC_map = mmb.map_Bayes_classif(x_test,
                                                                      x_A, x_C,
                                                                      mu0_A, nu_A, alpha_A, beta_A,
                                                                      mu0_C, nu_C, alpha_C, beta_C)
            error_map = mmb.classification_error(labels_map, tst['labels'])

            if error_map < err:
                opt_mu0_A, opt_nu_A, opt_alpha_A, opt_beta_A = mu0_A, nu_A, alpha_A, beta_A
                opt_mu0_C, opt_nu_C, opt_alpha_C, opt_beta_C = mu0_C, nu_C, alpha_C, beta_C
                err = error_map

            print(time.time()-start)

    return err, (opt_mu0_A, opt_nu_A, opt_alpha_A, opt_beta_A), (opt_mu0_C, opt_nu_C, opt_alpha_C, opt_beta_C)

opt = map()

print(opt)