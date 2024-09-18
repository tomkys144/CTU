#!/usr/bin/python
# -*- coding: utf-8 -*-

import numpy as np
import matplotlib.pyplot as plt
import time
import copy


# layer interface - do not modify
class Layer:
    def forward(self, x):
        raise NotImplementedError()

    def backward(self, dL_wrt_output):
        raise NotImplementedError()

    def params(self):
        return {}

    def grads(self):
        return {}


# loss interface - do not modify
class Loss:
    def forward(self, x, y):
        raise NotImplementedError()

    def backward(self):
        raise NotImplementedError()


class Linear(Layer):
    """
    Implements the fully-connected layer with bias, f(x) = x*W + b.
    ("Linear" is another name for "FullyConnected", at least in PyTorch)
    """

    def __init__(self, input_dimension, output_dimension):
        """
        :param input_dimension:   number of inputs (scalar)
        :param output_dimension:  number of outputs (scalar)
        """
        self.input_dimension = input_dimension
        self.output_dimension = output_dimension
        # random weights and bias initialization - do not change.
        self.W = np.random.randn(input_dimension, output_dimension) / 100
        self.b = np.random.randn(1, output_dimension) / 100

        self.dL_wrt_W = None
        self.dL_wrt_b = None

        self.x = None

    def forward(self, x):
        """
        :param x:  layer input - np.array (batch_sz, input_dimension)
        :return:   layer output - np.array (batch_sz, output_dimension)
        """
        self.x = x.copy()
        output = np.dot(x, self.W) + self.b
        return output

    def backward(self, dL_wrt_output):
        """
        :param dL_wrt_output:  gradient of loss wrt layer output - np.array (batch_sz, output_dimension)
        :return:               gradient of loss wrt layer input - np.array (batch_sz, input_dimension)

        note: also compute and store the gradients wrt the layer parameters
               dL_wrt_W - np array (batch_sz, input_dimension, output_dimension)
               dL_wrt_b - np array (batch_sz, 1, output_dimension)
        """
        self.dL_wrt_b = dL_wrt_output[:, np.newaxis]

        self.dL_wrt_W = (np.copy(self.x).T[np.newaxis] * dL_wrt_output.T[:, np.newaxis]).T

        dL_wrt_x = np.dot(dL_wrt_output, np.copy(self.W).T)
        return dL_wrt_x

    def params(self):
        return {'W': self.W, 'b': self.b}

    def grads(self):
        return {'W': self.dL_wrt_W, 'b': self.dL_wrt_b}


class ReLU(Layer):
    """
    ReLU or REctified Linear Unit is a simple yet powerful activation that computes f(x) = max(0, x).
    """

    def __init__(self):
        # need to store forward pass inputs for backpropagation
        self.x = None

    def forward(self, x):
        """
        :param x:  arbitrary shaped np array
        :return:   ReLU activation (same shape as x)
        """
        self.x = x.copy()
        output = np.zeros(x.shape)
        output[x > 0] = x[x > 0]
        return output

    def backward(self, dL_wrt_output):
        """
        :param dL_wrt_output: gradient of loss wrt layer output (same shape as forward x)
        :return:              gradient of loss wrt layer input (same shape as forward x)
        """
        dL_wrt_x = np.zeros(dL_wrt_output.shape)
        dL_wrt_x[self.x > 0] = dL_wrt_output[self.x > 0]
        return dL_wrt_x


class Sigmoid(Layer):
    """
    Implements a logistic sigmoid activation layer f(x) = 1/(1 + e^-x)
    """

    def __init__(self):
        self.a = None

    def forward(self, x):
        """
        :param x:  arbitrary shaped np array
        :return:   Logistic sigmoid activation (same shape as x)
        """
        output = 1 / (1 + np.exp(-x))
        self.a = np.copy(output)
        return output

    def backward(self, dL_wrt_output):
        """
        :param dL_wrt_output: gradient of loss wrt layer output (same shape as forward x)
        :return:              gradient of loss wrt layer input (same shape as forward x)
        """
        dL_wrt_x = dL_wrt_output * self.a * (1 - self.a)
        return dL_wrt_x


class SE(Loss):
    """
    Implements a mean-squared-error between inputs.
    """

    def __init__(self):
        self.x = None
        self.y = None

    def forward(self, x, y):
        """
        :param x:  np array, arbitrary shape
        :param y:  np array, same shape as x
        :return:   squared-error - np array, same shape as x
        """
        self.x = x.copy()
        self.y = y.copy()

        output = (x - y) ** 2
        return output

    def backward(self):
        """
        :return:  gradient wrt the first layer input (x) - np array, same shape as x

        Note: The second input will be the ground truth label, which is fixed.
              No need to propagate gradient there
        """

        dL_wrt_x = 2 * (self.x - self.y)
        return dL_wrt_x


################################################################################
#####                                                                      #####
#####                            Visualization                             #####
#####                                                                      #####
#####             Below this line are already prepared methods             #####
#####                                                                      #####
#####                    You do not have to modify this                    #####
#####                                                                      #####
################################################################################

def visualize_data(data, legend=None, title=None, xlabel=None, ylabel=None, save_filepath=None, show=True):
    """
    visualize_data(data, legend, title, xlabel, ylabel, save_filepath, show)

    :param data:            list of 1D input data
    :param legend:          list of data labels (same size as data, optional)
    :param title:           figure title, string (optional)
    :param xlabel:          x-axis label, string (optional)
    :param ylabel:          y-axis label, string (optional)
    :param save_filepath:   name and path for saving (optional)
    :param show:            showing figure, boolean
    :return:
    """

    if title:
        plt.title(title)
    for d in data:
        plt.plot(np.arange(len(d)), d)
    if xlabel:
        plt.xlabel(xlabel)
    if ylabel:
        plt.ylabel(ylabel)
    if legend:
        plt.legend(legend)
    if save_filepath:
        plt.savefig(save_filepath)
    if show:
        plt.show()


def visualize_xy(data, legend=None, title=None, xlabel=None, ylabel=None, save_filepath=None, show=True, **kwargs):
    """
    visualize_data(data, legend, title, xlabel, ylabel, save_filepath, show)

    :param data:            list of 2D input data tuples
                            i.e.: data = [(xdata, ydata)]
    :param legend:          list of data labels (same size as data, optional)
    :param title:           figure title, string (optional)
    :param xlabel:          x-axis label, string (optional)
    :param ylabel:          y-axis label, string (optional)
    :param save_filepath:   name and path for saving (optional)
    :param show:            showing figure, boolean
    :return:
    """
    axis = kwargs.get('axis', None)
    grid = kwargs.get('grid', None)
    linestyle = kwargs.get('linestyle', '-')

    if title:
        plt.title(title)
    for d in data:
        plt.plot(d[0], d[1], linestyle)
    if xlabel:
        plt.xlabel(xlabel)
    if ylabel:
        plt.ylabel(ylabel)
    if legend:
        plt.legend(legend)

    if axis:
        plt.axis(axis)
    if grid:
        plt.grid()

    if save_filepath:
        plt.savefig(save_filepath)
    if show:
        plt.show()


def show_classification(test_images, labels, letters):
    """
    show_classification(test_images, labels, letters)

    create montages of images according to estimated labels

    :param test_images:     np array (h, w, n)
    :param labels:          labels for input images np array (n,)
    :param letters:         string with letters, e.g. 'CN'
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

    for i in range(len(letters)):
        imgs = test_images[:, :, labels == i]
        subfig = plt.subplot(1, len(letters), i + 1)
        montage(imgs)
        plt.title(letters[i])


def load_data(path, class_a, class_b):
    with np.load(path) as f:
        x_train, y_train = f['x_train'], f['y_train']
        x_test, y_test = f['x_test'], f['y_test']

        x_train = x_train.reshape(-1, 28 * 28)
        x_test = x_test.reshape(-1, 28 * 28)

        X_trn = x_train[np.logical_or(y_train == class_a,
                                      y_train == class_b), :]
        y_trn = y_train[np.logical_or(y_train == class_a,
                                      y_train == class_b)]
        y_trn = y_trn.reshape(-1, 1)
        y_trn[y_trn == class_a] = 0
        y_trn[y_trn == class_b] = 1

        y_tst = y_test[np.logical_or(y_test == class_a,
                                     y_test == class_b)]
        y_tst = y_tst.reshape(-1, 1)
        y_tst[y_tst == class_a] = 0
        y_tst[y_tst == class_b] = 1

        # 0-1 normalize the images
        trn_mean = np.mean(X_trn)
        trn_std = np.std(X_trn)

        X_trn = (X_trn - trn_mean) / trn_std

        X_tst = x_test[np.logical_or(y_test == class_a,
                                     y_test == class_b), :]

        X_tst = (X_tst - trn_mean) / trn_std
        return (X_trn, y_trn), (X_tst, y_tst)


################################################################################
#####                                                                      #####
#####                           AE related stuff                           #####
#####                                                                      #####
#####                          Do NOT motify this                          #####
#####                                                                      #####
################################################################################

def get_relu_class(*_):
    return [ReLU]


def get_linear_class(*_):
    return [Linear]


def get_sigmoid_class(*_):
    return [Sigmoid]


def get_se_loss_class(*_):
    return [SE]


################################################################################
#####                                                                      #####
#####             Below this line you may insert debugging code            #####
#####                                                                      #####
#####                  Already prepared -- You can modify                  #####
#####                                                                      #####
################################################################################

def main():
    """
    # Code for training network and printing its results only.
    # Rest of the code is prepared in the jupyter notebook.
    """

    # set hyperparameters
    learning_rate = 10
    batch_size = 20
    N_epochs = 90
    validation_set_fraction = 0.5

    print_each = 30

    # load data - set which two MNIST digits you want to classify
    class_a = 4
    class_b = 9

    (X_trn, y_trn), (X_tst, y_tst) = load_data('full-mnist.npz',
                                               class_a,
                                               class_b)

    N_trn, D = X_trn.shape
    assert D == 28 * 28
    assert y_trn.shape == (N_trn, 1)

    # Shuffle the dataset
    trn_indices = np.arange(N_trn)
    np.random.shuffle(trn_indices)
    X_trn = X_trn[trn_indices, :]
    y_trn = y_trn[trn_indices, :]

    # Split into train/val
    idx_split = int(np.round(N_trn * validation_set_fraction))

    X_val = X_trn[:idx_split, :]
    X_trn = X_trn[idx_split:, :]
    N_trn = X_trn.shape[0]
    N_val = X_val.shape[0]

    y_val = y_trn[:idx_split, :]
    y_trn = y_trn[idx_split:, :]

    # Now, the magic happens - we build a model...
    model = [Linear(D, 3), ReLU(), Linear(5, 1), Sigmoid()]
    trn_head = SE()

    # And train!
    model_best_params = []
    trn_losses = []
    val_losses = []
    best_val_loss_epoch = 0

    batch_count = int(np.ceil(N_trn / batch_size))
    for epoch in range(N_epochs):
        try:
            cumulative_epoch_trn_loss = 0  # just for reporting progress
            time_start = time.time()
            for batch_i in range(batch_count):
                # load the minibatch:
                batch_idx = range(batch_i * batch_size,
                                  min(N_trn, (batch_i + 1) * batch_size))

                activation = X_trn[batch_idx]

                # forward pass:
                for layer in model:
                    activation = layer.forward(activation)

                loss = trn_head.forward(activation, y_trn[batch_idx])
                trn_loss = loss.mean()

                cumulative_epoch_trn_loss += trn_loss

                # backward pass:
                grad_output = trn_head.backward()
                for layer in reversed(model):
                    grad_output = layer.backward(grad_output)

                # Update the weights with gradient descent
                for layer in model:
                    for param_name, param_value in layer.params().items():
                        param_value -= learning_rate * layer.grads()[param_name].mean(
                            axis=0)  # mean across the minibatch

            # validation
            activation = X_val.copy()
            for layer in model:
                activation = layer.forward(activation)
            val_losses.append(trn_head.forward(activation, y_val).mean())

            # remember the best model so far
            if len(val_losses) == 0 or val_losses[-1] < val_losses[best_val_loss_epoch]:
                best_val_loss_epoch = epoch
                model_best_params = [copy.deepcopy(layer.params()) for layer in model]

            trn_losses.append(cumulative_epoch_trn_loss / batch_count)
            if epoch % print_each == 0:
                print("[{:04d}][TRN] MSE loss {:2f} ({:.1f}s)".format(epoch, trn_losses[-1], time.time() - time_start))
                print("[{:04d}][VAL] MSE loss {:2f}".format(epoch, val_losses[-1]))
        except KeyboardInterrupt:
            print('Early exit')
            break

    # Plot epochs
    visualize_data([val_losses, trn_losses], legend=['validation', 'training'],
                   xlabel='epoch', ylabel='MSE', save_filepath='numpy_nn_training.png')

    # TST load best model
    print('Best VAL model loss {:.4f} at epoch #{:d}.'.format(val_losses[best_val_loss_epoch], best_val_loss_epoch))
    for layer_id in range(len(model_best_params)):
        for key, value in model_best_params[layer_id].items():
            model[layer_id].params()[key] = value

    # TST forward pass
    activation = X_tst
    for layer in model:
        activation = layer.forward(activation)
    y_hat = (activation > 0.5).astype(int)

    loss = trn_head.forward(activation, y_tst)
    print("[TST] MSE loss {:.4f}".format(loss.mean()))

    test_error = np.mean(y_hat != y_tst)
    print("[TST] error {:.4f}".format(test_error))

    plt.figure(figsize=(15, 10))
    plt.title('NN classification: test error {:.4f}'.format(test_error))
    show_classification(X_tst.transpose(1, 0).reshape(28, 28, -1), y_hat.squeeze(), '{}{}'.format(class_a,
                                                                                                  class_b))
    plt.savefig('numpy_nn_classification.png')
    plt.show()


def lin_test_func():
    input_dim, output_dim, batch_size = 3, 2, 2
    linear_layer = Linear(input_dim, output_dim)
    linear_layer.W = np.linspace(1, -1, input_dim * output_dim).reshape(input_dim, output_dim)
    linear_layer.b = np.linspace(-0.5, 0.5, output_dim).reshape(1, output_dim)
    x = np.linspace(-2, 2, batch_size * input_dim).reshape(batch_size, input_dim)

    forward_output = linear_layer.forward(x)
    y = np.array([[-2.5, -0.06], [-1.06, -1.5]])

    dL_wrt_output = np.linspace(1, 2, output_dim * batch_size).reshape(batch_size, output_dim)

    dL_wrt_x = linear_layer.backward(dL_wrt_output)

    print(f'Backward pass of your linear layer:\n{dL_wrt_x}\n\n' + \
          f'Weights gradients:\n{linear_layer.dL_wrt_W}\n\n' + \
          f'Bias gradients:\n{linear_layer.dL_wrt_b}')


def relu_test_func():
    n_data_bw = 9
    dL_wrt_output_relu = np.linspace(-1, 1, n_data_bw)
    dL_wrt_output_relu = np.vstack((dL_wrt_output_relu, dL_wrt_output_relu))
    x_relu = np.linspace(-1, 1, n_data_bw)
    x_relu = np.vstack((x_relu, x_relu))
    relu_layer = ReLU()
    _ = relu_layer.forward(x_relu)
    dL_wrt_x_relu = relu_layer.backward(dL_wrt_output_relu)
    print(f'Backward pass of your ReLU layer:\n{dL_wrt_x_relu}')


def sigmoid_test_func():
    n_data_bw = 5
    dL_wrt_output_sigmoid = np.linspace(-10, 10, n_data_bw)
    dL_wrt_output_sigmoid = np.vstack((dL_wrt_output_sigmoid, dL_wrt_output_sigmoid))
    x_sigmoid = np.linspace(-5, 5, n_data_bw)
    x_sigmoid = np.vstack((x_sigmoid, x_sigmoid))
    sigmoid_layer = Sigmoid()
    _ = sigmoid_layer.forward(x_sigmoid)
    dL_wrt_x_sigmoid = sigmoid_layer.backward(dL_wrt_output_sigmoid)
    print(f'Backward pass of your Sigmoid layer:\n{dL_wrt_x_sigmoid}')


def SE_test_func():
    n_data_bw = 9
    dL_wrt_output_se = np.linspace(-10, 10, n_data_bw)
    x_se = np.linspace(-5, 5, n_data_bw)
    se_layer = SE()
    _ = se_layer.forward(x_se, 0.5 * x_se)
    dL_wrt_x_se = se_layer.backward()
    print(f'Backward pass of your Squared Error Loss layer:\n{dL_wrt_x_se}')


if __name__ == '__main__':
    main()