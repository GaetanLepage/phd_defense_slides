# Slides layout

[TOC]


## TO DISCUSS
- Already too much?
- What do we put in the intro
- Do we talk about STFT at some point\
    -> It feels bad to not have a single plot of STFT/IPD/ILD except in the network schemas
- Should I include the overview of the thesis organization?\
    -> Maybe in the "extra slides"

## Introduction

> Things to present:
> - Social robotics
> - Acoustic perception

- (social) robotics
- Acoustic perception

## Acoustic simulation (simulator)

_8 slides_

> Two possible ways to start:
> - Importance of simulation for applying data-intensive methods
> - Start directly with introducing how acoustic reverberation works
>
> Basically, either we insist on the simulation part or on the acoustic part
>
> Where do we talk about the downstream use-cases

1. Modelling realistic acoustic environments:
    - Motivation
    - In the real-world, there are reverberation -> We need to model this phenomenon
    - Essential to use data-intensive techniques
1. RIR
    - (fig) Schema
    - Convolution formula
1. Existing methods for reverberation simulation (taxonomy)
    - Numerical simulation
    - Geometrical Acoustics
        - Ray-tracing
        - ISM
1. My simulator
    - (fig) overall architecture
1. Audio-processing pipeline
    - (fig) pipeline schema
1. Code example?
1. Execution process
1. Conclusion
    - Mention how we use it later?
    - Transition to downstream tasks

### Things ignored
- Arrays
- STFT, interaural features
- Reverberation bootstrapping
- Performance :/

## Active Sound Source Localization

_12 slides_

1. Motivation
    - Robots are moving
    - Our previous static SSL method cannot reliably predict the distance
    => Leverage robot movement to predict source positions
1. Problem statement
    - We do not control the robot movement
1. Method#1: Concept / general ideal
    - Egocentric maps
1. Method#2: Pipeline
    - (fig) pipeline schema
    - (fig) Explain map shifting
1. Method#3a: static SSL model
    - General idea of spectrum regression
    - (fig) Add representation (and formula) of DoA representation
    - Ground truth encoding
1. Method#3b: SSL backbone architecture
    - (fig) Figure of the architecture
    - Mention the loss function
    - Mention the training process
1. Method#3: Aggregation strategies
    - Simple averaging strategy
    - (fig) U-Net
1. Method#4: Clustering
1. Exp#1: Metrics
1. Exp#1': Experimental setup
    - Figure of the starting position
    - Dataset generation
1. Exp#2: Comparison of aggregation strategies
    - Table (quantitative performance)
    - Visualization of the results
1. Exp#3 (OPTIONAL): Other ablation studies / tricks:
    - Impact of upstream SSL model
    - FoV
    - Resolution
    - clipping
1. Conclusion

### Things ignored
- Active-SSL algorithm <- TO DISCUSS


## Deep Reinforcement Learning for Sound-Driven Navigation

_12 slides_

1. Motivation:
    - Move to hear better
1. RL: flash introduction
    - Framework to deal with sequence decision problems with uncertainty
    - Give examples of uses in robotics
1. PPO:
    - Concept of PG algorithms (difference with Q-learning)
    - General principle
    - present algorithm (main steps)
1. Problem statement (could go before RL)
    - WER as reward
    - Discrete movement
    - Finite horizon
    - source positions?
1. WER cost maps
    - (ugly) formula?
    - (fig) Example
1. Agent:
    - Network architecture
    - Backbone pre-training
1. Focus on Backbone pre-training
    - (fig) Single-source SSL architecture
1. Reward
    - Importance of reward design
    - Final formula
    - penalization terms
1. Obtained trajectories
    - (fig) Examples of trajectories
1. Quantitative results
    - (table) comparison with baselines
1. Importance of backbone pre-training
1. Conclusion

### Things ignored
- All the explanations about RL
- Policy collapsing? <- TO DISCUSS
- Alternative cost-maps?

## Conclusion

_~2-3 slides_

1. Summary of contributions
1. Limitations? (do we mention them in the defense)
1. Future research perspectives
