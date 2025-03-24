import numpy as np
from collections import defaultdict

import evaluate
from abstractagent import AbstractAgent
from blackjack import BlackjackEnv, BlackjackObservation, BlackjackAction
from carddeck import *


class SarsaAgent(AbstractAgent):
    """
    Here you will provide your implementation of SARSA method.
    You are supposed to implement train() method. If you want
    to, you can split the code in two phases - training and
    testing, but it is not a requirement.

    For SARSA explanation check AIMA book or Sutton and Burton
    book. You can choose any strategy and/or step-size function
    (learning rate) as long as you fulfil convergence criteria.
    """

    discount = .99

    Q = defaultdict(lambda: {BlackjackAction.HIT.value: 0, BlackjackAction.STAND.value: 0})
    K = defaultdict(lambda: {BlackjackAction.HIT.value: 0, BlackjackAction.STAND.value: 0})
    Q100 = []
    Q101 = []

    def train(self):
        for i in range(self.number_of_episodes):
            observation, _ = self.env.reset()
            # TODO your code here (and do not forget to set the number of episodes for learning in main)

            terminal = False

            eps0 = 1.0
            decay_const = 3/self.number_of_episodes
            eps = eps0 * np.exp(-decay_const * i)
            epsilon = max(0.05, eps)

            print(i, epsilon)

            while not terminal:

                state = self.get_state(observation)
                action = self.get_action(state, epsilon)

                next_observation, reward, terminal, _, _ = self.env.step(action)

                next_state = self.get_state(next_observation)
                next_action = self.get_action(next_state, epsilon)

                self.K[state][action] += 1
                alpha = 3 / (2 + self.K[state][action])

                target = reward + self.discount * self.Q[next_state][next_action]
                self.Q[state][action] = (1 - alpha) * self.Q[state][action] + alpha * target

                observation = next_observation

            self.Q100.append(self.Q[(10, 0, 0)][0])
            self.Q101.append(self.Q[(10, 0, 0)][1])

        # self.env.render()
        evaluate.plot_series(self.Q100)
        evaluate.plot_series(self.Q101)

    def get_action(self, state: tuple[int, int, int], epsilon: float) -> int:
        p = np.random.random()

        actions = [BlackjackAction.HIT, BlackjackAction.STAND]

        if p < epsilon:
            return actions[np.random.choice(2)].value

        if self.Q[state][BlackjackAction.HIT.value] == self.Q[state][BlackjackAction.STAND.value]:
            return actions[np.random.choice(2)].value

        if self.Q[state][BlackjackAction.HIT.value] > self.Q[state][BlackjackAction.STAND.value]:
            return BlackjackAction.HIT.value

        return BlackjackAction.STAND.value

    def get_state(self, observation: BlackjackObservation) -> tuple[int, int, int]:
        if observation.player_hand.value() <= 10:
            return 10, 0, 0

        if observation.player_hand.value() >= 22:
            return 22, 0, 0

        return observation.player_hand.value(), observation.dealer_hand.value(), len(observation.player_hand.cards)

    def get_hypothesis(self, observation: BlackjackObservation, terminal: bool, action: int) -> float:
        """
        Implement this method so that I can test your code. This method is supposed to return your learned Q value for
        particular observation and action.

        :param observation: The observation as in the game. Contains information about what the player sees - player's
        hand and dealer's hand.
        :param terminal: Whether the hands were seen after the end of the game, i.e. whether the state is terminal.
        :param action: Action for Q-value.
        :return: The learned Q-value for the given observation and action.
        """
        state = self.get_state(observation)

        return self.Q[state][action]
