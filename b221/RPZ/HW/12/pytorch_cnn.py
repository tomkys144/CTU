import torch
import torch.nn as nn
import torch.nn.functional as F
import torch.optim as optim
from torchvision import datasets, transforms


class FCNet(nn.Module):
    def __init__(self):
        super(FCNet, self).__init__()
        self.fc = nn.Linear(in_features=28 * 28, out_features=10)

    def forward(self, x):
        x = torch.flatten(x, start_dim=1)
        x = self.fc(x)
        output = F.log_softmax(x, dim=1)
        return output


class SimpleCNN(nn.Module):
    def __init__(self):
        super(SimpleCNN, self).__init__()
        self.conv = nn.Conv2d(in_channels=1,
                              out_channels=10,
                              kernel_size=3,
                              stride=2,
                              padding=1)
        self.con2 = nn.Conv2d(in_channels=10,
                              out_channels=20,
                              kernel_size=5,
                              stride=2,
                              padding=2)

        self.fc = nn.Linear(in_features=28 * 28 * 20 // (4 * 4),
                            out_features=10)

    def forward(self, x):
        x = self.conv(x)
        x = F.relu(x)
        x = self.con2(x)
        x = torch.relu(x)
        x = torch.flatten(x, start_dim=1)
        x = self.fc(x)
        output = F.log_softmax(x, dim=1)
        return output


class MyNet(nn.Module):
    """
    Experiment with all possible settings mentioned in the CW page
    """

    def __init__(self):
        super(MyNet, self).__init__()
        channels = [8, 20]
        self.conv1 = nn.Conv2d(in_channels=1, out_channels=channels[0], kernel_size=5, stride=1, padding=2)
        self.conv2 = nn.Conv2d(in_channels=channels[0], out_channels=channels[1], kernel_size=5, stride=1, padding=2)

        self.pool1 = nn.AvgPool2d(kernel_size=2, stride=2)
        self.pool2 = nn.AvgPool2d(kernel_size=2, stride=2)

        neurons = [200, 100, 10]
        self.fc1 = nn.Linear(in_features=980, out_features=neurons[0])
        self.fc2 = nn.Linear(in_features=neurons[0], out_features=neurons[1])
        self.fc3 = nn.Linear(in_features=neurons[1], out_features=neurons[2])

    def forward(self, x):
        x = self.conv1(x)
        x = torch.relu(x)
        x = self.pool1(x)
        x = self.conv2(x)
        x = torch.relu(x)
        x = self.pool2(x)
        x = torch.flatten(x, start_dim=1)
        x = self.fc1(x)
        x = torch.relu(x)
        x = self.fc2(x)
        x = torch.relu(x)
        x = self.fc3(x)

        output = torch.log_softmax(x, dim=1)
        return output


def classify(model, x):
    """
    :param model:    network model object
    :param x:        (batch_sz, 1, 28, 28) tensor - batch of images to classify

    :return labels:  (batch_sz, ) torch tensor with class labels
    """
    px = model.forward(x)
    labels = torch.argmax(px, dim=1)
    return labels


def get_model_class(_):
    """ Do not change, needed for AE """
    return [MyNet]


def train():
    batch_sz = 64

    learning_rate = 0.005
    epochs = 200

    dataset = datasets.FashionMNIST('data', train=True, download=True,
                                    transform=transforms.ToTensor())

    trn_size = int(0.09 * len(dataset))
    val_size = int(0.01 * len(dataset))
    add_size = len(dataset) - trn_size - val_size  # you don't need ADDitional dataset to pass

    trn_dataset, val_dataset, add_dataset = torch.utils.data.random_split(dataset, [trn_size,
                                                                                    val_size,
                                                                                    add_size])
    trn_loader = torch.utils.data.DataLoader(trn_dataset,
                                             batch_size=batch_sz,
                                             shuffle=True)

    val_loader = torch.utils.data.DataLoader(val_dataset,
                                             batch_size=batch_sz,
                                             shuffle=False)

    device = torch.device("cpu")
    model = MyNet().to(device)

    optimizer = optim.SGD(model.parameters(), lr=learning_rate)

    for epoch in range(1, epochs + 1):
        # training
        model.train()
        for i_batch, (x, y) in enumerate(trn_loader):
            x, y = x.to(device), y.to(device)
            optimizer.zero_grad()
            net_output = model(x)
            loss = F.nll_loss(net_output, y)
            loss.backward()
            optimizer.step()

            if i_batch % 100 == 0:
                print('[TRN] Train epoch: {}, batch: {}\tLoss: {:.4f}'.format(
                    epoch, i_batch, loss.item()))

        # validation
        model.eval()
        correct = 0
        with torch.no_grad():
            for x, y in val_loader:
                x, y = x.to(device), y.to(device)
                net_output = model(x)

                prediction = classify(model, x)
                correct += prediction.eq(y).sum().item()
        val_accuracy = correct / len(val_loader.dataset)
        print('[VAL] Validation accuracy: {:.2f}%'.format(100 * val_accuracy))

        torch.save(model.state_dict(), "model.pt")


if __name__ == '__main__':
    train()