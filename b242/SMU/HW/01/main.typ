#import "@local/ctu-report:0.1.0": *
#import "@preview/subpar:0.2.1"
#import "@preview/unify:0.7.1": num

#show: it => ctu-report(
  doc-category: "B4M36SMU",
  doc-title: "Project 1 - Reinforcement Learning",
  author: "Tomáš Kysela",
  language: "en",
  show-outline: false,
  it,
)

#set math.equation(numbering: "(1)")

= State proposals

== Sum of player's hand, Dealer's card, Ace <subsec:state1>

In this state representation we use three values. First one is sum of our hand, second value of card, dealer has face-up and the last one is bool stating if we have an ace which counts as 11. We can calculate number of states using @eq:state1.

$
  "Hand sum" times "Dealer's card" times "Ace existence" &= \
  18 times 10 times 2 &= 360
$ <eq:state1>

== Player's hand composition, Dealer's card <subsec:state2>

Unlike in #ref(<subsec:state1>, supplement: "Proposition"), here we store exact hand composition, most likely using number of aces, number of face cards. This allows for better decision making based on hand composition, since we can better predict deck composition. Number of states is calculated using @eq:state2.

$
  "Number of aces" times "Number of face cards" &times\ "Number of other cards" times "Dealer's card" &= \
  5 times 3 times 508 times 10 &= 76200
$ <eq:state2>

== Sum of player's hand, Number of cards, Dealer's card <subsec:state3>


This state is somewhat middleground between previous states. We know if we used multiple small cards or few bigger cards to get to this sum. As stated in @eq:state3, there is much lower number of states than in #ref(<subsec:state2>, supplement: "Proposition"), but more than #ref(<subsec:state1>, supplement: "Proposition").

$
  "Hand sum" times "Number of cards" times "Dealer's card" &= \
  18 times 7 times 10 &= 1260
$ <eq:state3>

= Chosen state representation

In my implementation I chose to use state representation as proposed in #ref(<subsec:state3>, supplement: "Proposition"). To reduce state space, merge of all states with value of player's hand of 10 and lower are merged, since here, we always want to _HIT_. Also for ease of coding, states with value of player's hand of 22 and higher are merged, since this is always a bust and it's Q/U value is never updated.

With all these simplifications, the state space is small enough, that we can use exact methods without needing too much time to finish.

= Evaluation of agents

In this section we compare multiple agents. Most of these agents could run with much lower number of epochs, but for ease of comparison and same time axis on graphs, we used #num("1e6") epochs, which was the highest number of optimal numbers of epochs for these agents.

First possible comparison between agents is using rewards. For this I used moving average of length 1000, resulting in graphs as shown in @img:agent_comp. Here we can see that SARSA agent is clearly learning, but for comparison between other agents this is quite impractical. For that I fitted third degree polynom to each reward progression resulting in comparison shown in @img:trends. From this graph it's quite clear, that our epsilon-greedy policy is working, since overtime the SARSA agent moves from rewards of an random policy to at least dealer policy rewards, possibly better.

#subpar.grid(
  figure(
    image(
      "assets/rand_agent.png",
      width: 5cm,
    ),
    caption: [ Random agent ],
  ),
  <img:random>,
  figure(
    image(
      "assets/dealer_agent.png",
      width: 5cm,
    ),
    caption: [ Dealer agent ],
  ),
  <img:dealer>,
  figure(
    image(
      "assets/td_agent.png",
      width: 5cm,
    ),
    caption: [ TD agent ],
  ),
  <img:td>,
  figure(
    image(
      "assets/sarsa_agent.png",
      width: 5cm,
    ),
    caption: [ SARSA agent ],
  ),
  <img:sarsa>,
  columns: (6cm, 6cm),
  caption: [ Rewards over epochs ],
  label: <img:agent_comp>,
)

#figure(
  image(
    "assets/trends.png",
    width: 10cm,
  ),
  caption: [ Comparison of rewards using 3d degree polynoms ],
) <img:trends>

To verify my agents learn and converge we can look at state with sum of player's hand 10 and lower. Progression of U and Q values are shown in @img:qu10. These graphs show, that all values converge, U values learned by TD agent significantly faster. This also shows, that Q value for action _HIT_ converges to higher score than Q value for _STAND_ action, which is expected, since we always want to _HIT_ if we have lower sum than 11.

#subpar.grid(
  figure(
    image(
      "assets/sarsa_100.png",
      width: 5cm,
    ),
    caption: [ Q values for _STAND_ action learned by SARSA agent ],
  ),
  <img:q100>,
  figure(
    image(
      "assets/sarsa_101.png",
      width: 5cm,
    ),
    caption: [ Q values for _HIT_ action learned by SARSA agent ],
  ),
  <img:q101>,
  figure(
    image(
      "assets/td_u10.png",
      width: 5cm,
    ),
    caption: [ U values learned by TD agent ],
  ),
  <img:u10>,
  columns: (6cm, 6cm),
  caption: [ Q/U values for state (10, 0, 0) ],
  label: <img:qu10>,
)
