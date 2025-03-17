from collections import defaultdict

import evaluate
from abstractagent import AbstractAgent
from blackjack import BlackjackObservation, BlackjackEnv, BlackjackAction
from carddeck import *


class TDAgent(AbstractAgent):
    """
    Implementation of an agent that plays the same strategy as the dealer.
    This means that the agent draws a card when sum of cards in his hand
    is less than 17.

    Your goal is to modify train() method to learn the state utility function
    and the get_hypothesis() method that returns the state utility function.
    I.e. you need to change this agent to a passive reinforcement learning
    agent that learns utility estimates using temporal difference method.
    """

    discount = .99

    U = defaultdict(lambda: 0)
    K = defaultdict(lambda: 0)
    U10 = []

    def train(self):
        for i in range(self.number_of_episodes):
            print(i)
            observation, _ = self.env.reset()
            terminal = False
            reward = 0
            while not terminal:
                # render method will print you the situation in the terminal
                # self.env.render()
                action = self.receive_observation_and_get_action(observation, terminal)
                next_observation, reward, terminal, _, _ = self.env.step(action)

                state = self.get_state(observation)
                next_state = self.get_state(next_observation)

                if state not in self.U:
                    self.U[state] = 0
                    self.K[state] = 0

                if next_state not in self.U:
                    self.U[next_state] = 0
                    self.K[next_state] = 0

                self.K[state] += 1
                alpha = 3 / (2 + self.K[state])

                target = reward + self.discount * self.U[next_state]

                self.U[state] = (1 - alpha) * self.U[state] + alpha * target

                observation = next_observation

            # self.U10.append(self.U[(10, 0, 0)])

        self.env.render()

        # evaluate.plot_series(self.U10)

    def receive_observation_and_get_action(self, observation: BlackjackObservation, terminal: bool) -> int:
        return BlackjackAction.HIT.value if observation.player_hand.value() < 17 else BlackjackAction.STAND.value

    def get_state(self, observation: BlackjackObservation) -> tuple[int, int, int]:
        if observation.player_hand.value() <= 10:
            return 10, 0, 0

        if observation.player_hand.value() >= 22:
            return 22, 0, 0

        return observation.player_hand.value(), observation.dealer_hand.value(), len(observation.player_hand.cards)

    def get_hypothesis(self, observation: BlackjackObservation, terminal: bool) -> float:
        """
        Implement this method so that I can test your code. This method is supposed to return your learned U value for
        particular observation.

        :param observation: The observation as in the game. Contains information about what the player sees - player's
        hand and dealer's hand.
        :param terminal: Whether the hands were seen after the end of the game, i.e. whether the state is terminal.
        :return: The learned U-value for the given observation.
        """

        state = self.get_state(observation)

        return self.U[state]
