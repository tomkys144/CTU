# matplotlib.use('Agg')
import matplotlib.pyplot as plt
from typing import List

import numpy as np

def evaluate(rewards: List[float], name: str):
    # TODO implement your own code here if you want to
    # or alternatively you can modify the existing code
    # if you reuse the averaging, you should probably change the parameters

    np.set_printoptions(precision=5)
    ma_rewards = simple_moving_average(rewards, int(1e3))

    # print("Rewards:")
    # print(rewards)
    print("Simple moving average:")
    # if you reuse this code, you should change the parameters
    print(ma_rewards)
    print("Exponential moving average")
    print(exponential_moving_average(rewards, 0.2))
    print("Average")
    print(np.sum(rewards) / len(rewards))

    # to use this plot function you have to install matplotlib
    # use conda install matplotlib
    x = np.linspace(1, len(ma_rewards), len(ma_rewards))
    z = np.polyfit(x, ma_rewards, 3)
    p = np.poly1d(z)
    plot_series(ma_rewards, p(x))

    np.savez("data/" + name + ".npz", ma_rewards=ma_rewards, p=p)


# check Wikipedia: https://en.wikipedia.org/wiki/Moving_average
def simple_moving_average(x: List[float], n: int) -> float:
    mean = np.zeros(len(x) - n + 1)
    tmp_sum = np.sum(x[0:n])
    for i in range(len(mean) - 1):
        mean[i] = tmp_sum
        tmp_sum -= x[i]
        tmp_sum += x[i + n]
    mean[len(mean) - 1] = tmp_sum
    return mean / n


# check Wikipedia: https://en.wikipedia.org/wiki/Moving_average
def exponential_moving_average(x: List[float], alpha: float) -> float:
    mean = np.zeros(len(x))
    mean[0] = x[0]
    for i in range(1, len(x)):
        mean[i] = alpha * x[i] + (1.0 - alpha) * mean[i - 1]
    return mean


# you can use this function to get a plot
# you need first to install matplotlib (conda install matplotlib)
# and then uncomment this function and lines 1-3
def plot_series(arr, trend=None):
    plt.plot(arr)

    if trend is not None:
        plt.plot(trend, linewidth=2)
    # plt.savefig('assets/moving_average.png')
    plt.show()


def plot_hist(data, labels):
    plt.boxplot(data, tick_labels=labels)

    plt.show()

def plot_trends(data, labels, N):
    x = np.arange(N)

    for i in range(len(labels)):
        k = data[i]
        p = np.poly1d(k)
        plt.plot(p(x), linewidth=2)

    plt.legend(labels)

    plt.show()


if __name__ == '__main__':
    dealer = np.load("data/dealer.npz")
    rand = np.load("data/rand.npz")
    td = np.load("data/td.npz")
    sarsa = np.load("data/sarsa.npz")

    data = [rand["ma_rewards"], dealer["ma_rewards"], td["ma_rewards"], sarsa["ma_rewards"]]
    labels = ["Random", "Dealer", "TD", "SARSA"]

    plot_hist(data, labels)

    data2 = [rand["p"], dealer["p"], td["p"], sarsa["p"]]
    N = 1e6

    plot_trends(data2, labels, N)

