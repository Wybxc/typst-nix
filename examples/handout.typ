#import "@local/handout:0.2.0": *

#show: project.with(
  title: "Handout 01",
  authors: (
    "Wybxc",
  ),
  date: "September 2023",
)

= Bounded Subset Sum

== (a)

Consider the case where $a_1 = 1/(1+ρ) C, a_2 = a_3 = dots.c = (1+ρ)/(2+ρ) C$. In this case, we have $a_1 + a_2 > C$, so according to the greedy algorithm, we obtain $T(S) = a_1 = 1/(1+ρ) C$.

However, the optimal solution is $T^*(S) >= a_2 = (1+ρ)/(2+ρ) C$, and we have $
(T^*(S))/T(S) = (1+ρ)/(2+ρ) " /" 1/(1+ρ) = (1+ρ)^2/(2+ρ) > ρ
$

Therefore, for any approximation ratio $ρ$, this greedy algorithm cannot reliably achieve it.

== (b)

1. If there exists $a_i>=C/2$, set the initial value of $S$ to be ${a_i}$; otherwise, set $S$ to be an empty set.
2. Run the greedy algorithm from part (1) with this initial value of $S$ to obtain the final value of $S$.

It can be proven that the algorithm described in part (b) will always find an $S$ that satisfies $T(S) >= C/2$, making it an approximation algorithm with an approximation ratio of 2.
