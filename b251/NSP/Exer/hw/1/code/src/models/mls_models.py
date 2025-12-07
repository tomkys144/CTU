from pyexpat import features
from typing import List

import numpy as np
import numpy.ma
import torch
import torch.nn as nn
from torch.nn import Module
from torch.utils.data import DataLoader, TensorDataset


class MLPModel(nn.Module):
    """
    A simple feed-forward network with one input/output unit, two hidden layers and tanh activation.

    Attributes
    ----------
    hidden_sizes : int
        Number of hidden units per hidden layer
    """

    def __init__(self, hidden_sizes: List[int] = (32, 32)):
        super().__init__()
        self.hidden_sizes = hidden_sizes
        self.layer1 = nn.Linear(1, self.hidden_sizes[0])
        self.layer2 = nn.Linear(self.hidden_sizes[0], self.hidden_sizes[1])
        self.outlayer = nn.Linear(self.hidden_sizes[1], 1)

    def forward(self, x):
        if not torch.is_tensor(x):
            x = torch.tensor(x, dtype=torch.float32)

        x = x.view((-1, 1)) # shape (batch_size, 1)

        l1 = self.layer1(x)
        z1 = torch.relu(l1)
        l2 = self.layer2(z1)
        z2 = torch.tanh(l2)
        out = self.outlayer(z2)

        return out

    def predict(self, x):
        out = self(x)

        return out.detach().numpy()

    def fit(self, data, targets, batch_size=5, learning_rate=5e-3, max_epochs=300):
        loss = nn.MSELoss()
        optimizer = torch.optim.Adam(self.parameters(), lr=learning_rate)

        if len(data.shape) < 2:
            data = torch.FloatTensor(data[:, np.newaxis])
        else:
            data = torch.FloatTensor(data)

        if len(targets.shape) < 2:
            targets = torch.FloatTensor(targets[:, np.newaxis])
        else:
            targets = torch.FloatTensor(targets)

        train_dataset = TensorDataset(data, targets)
        train_loader = DataLoader(train_dataset, batch_size=batch_size, shuffle=True)

        losses = []
        for epoch in range(max_epochs):
            for x, y in train_loader:
                predictions = self(x)
                batch_loss = loss(predictions, y)

                optimizer.zero_grad()
                batch_loss.backward()
                optimizer.step()

            with torch.no_grad():
                predictions = self(train_dataset[:][0])
                train_loss = loss(predictions, train_dataset[:][1])
                losses.append(train_loss.detach().numpy())

        return losses

class PolynomialModel:
    def __init__(self, order: int):
        self.order = order
        self.coefficients = None

    def _calculate_features(self, x):
        return np.vander(x, self.order + 1, increasing=True)

    def predict(self, x):
        """Compute the network output for a given input and return the result as numpy array.

        Parameters
        ----------
        x : float or numpy.array or torch.Tensor
            The model input

        Returns
        ----------
        numpy.array
            The model output
        """
        features = self._calculate_features(x)

        out = np.dot(features, self.coefficients)

        return out

    def fit(self, data, targets):
        """Fit coefficients of the polynomial model on the given data.

        Parameters
        ----------
        data : numpy.array
            The input training samples
        targets : numpy.array
            The output training samples
        Returns
        ----------
        list
            The training set MSE score
        """
        features = self._calculate_features(data)

        self.coefficients, _, _, _ = np.linalg.lstsq(features, targets)

        predictions = self.predict(data)

        mse = np.mean(np.power(predictions - targets, 2))

        return mse


class RBFModel:
    def __init__(self, order: int, lengthscale: float = 10.):
        self.order = order
        self.lengthscale = lengthscale
        self.coefficients = None
        if order > 1:
            self.centers = np.linspace(-10, 10, self.order)
        else:
            self.centers = np.array([0])

    def _calculate_features(self, x):
        features = np.empty((len(x), self.order))
        for i, center in enumerate(self.centers):
            exp = (x - center)**2 / self.lengthscale
            featuresC = np.exp(-exp)
            features[:, i] = featuresC

        return features

    def predict(self, x):
        """Compute the network output for a given input and return the result as numpy array.

               Parameters
               ----------
               x : float or numpy.array or torch.Tensor
                   The model input

               Returns
               ----------
               numpy.array
                   The model output
               """
        features = self._calculate_features(x)

        out = np.dot(features, self.coefficients)

        return out

    def fit(self, data, targets):
        """Fit coefficients of the RBF model on the given data.

                Parameters
                ----------
                data : numpy.array
                    The input training samples
                targets : numpy.array
                    The output training samples
                Returns
                ----------
                list
                    The training set MSE score
                """
        features = self._calculate_features(data)

        self.coefficients, _, _, _ = np.linalg.lstsq(features, targets)

        predictions = self.predict(data)

        mse = np.mean(np.power(predictions - targets, 2))

        return mse
