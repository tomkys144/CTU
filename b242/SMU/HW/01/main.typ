#import "@local/ctu-report:0.1.0": *

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
