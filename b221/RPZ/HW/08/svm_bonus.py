from svm import *


def svm_one_v_all(X, y, C, options, classes):
    models = []

    for cls in classes:
        y_class = np.ones(y.size)
        y_class[y != cls] = -1

        model = svm(X, y_class, C, options)

        models.append(model)
    return models


def classif_svm_one_v_all(X, models, classes):
    y = np.zeros(len(classes), X.shape[1])

    for i in range(len(classes)):
        model = models[i]

        K = get_kernel(model['sv'], X, model['options'])

        y_classif = (model['alpha'] * model['y']).dot(K) + model['b']

        y[i, :] = y_classif

    classif = y.argmax(axis=0)

    return classif
