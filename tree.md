# Slides layout

## Introduction

> Things to present:
> - Social robotics
> - Acoustic perception

- (social) robotics
- Acoustic perception

## Acoustic simulation (simulator)

> Two possible ways to start:
> - Importance of simulation for applying data-intensive methods
> - Start directly with introducing how acoustic reverberation works
>
> Basically, either we insist on the simulation part or on the acoustic part
>
> Besides, things from Chap.2  that we will not mention here:
> - STFT, interaural features & co

- Modelling realistic acoustic environments:\
    - Motivation
    - In the real-world, there are reverberation -> We need to model this phenomenon
- Existing methods for reverberation simulation (taxonomy)
    - Numerical simulation
    - Geometrical Acoustics
        - Ray-tracing
        - ISM
-

## Sound source localization

- Motivation + task definition
    - Schema of the task
    - Variations:
        - Single-source
        - Multi-source
- Method#1a: Neural network for single-source
- Method#1b: Loss function for single-source
- Exp#1: Evaluation setup
    - Metrics (MAE)
    - Dataset
    - ...
- Exp#1b: impact of reverberation
    - Graph (and table?) of SSL performance depending on T_60

## Active Sound Source Localization

-> 9-11 slides

- Motivation
    - Robots are moving
    - Our previous static SSL method cannot reliably predict the distance
    => Leverage robot movement to predict source positions
- Problem statement
    - We do not control the robot movement
- Method#1: Concept / general ideal
    - Egocentric maps
- Method#2: Pipeline
- Method#3: Aggregation strategies
    - Simple averaging strategy
    - U-Net
- Method#4: Clustering
- Exp#1: Metrics
- Exp#1': Experimental setup
    - Figure of the starting position
    - Dataset generation
- Exp#2: Comparison of aggregation strategies
    - Table (quantitative performance)
    - Visualization of the results
- Exp#3 (OPTIONAL): Other ablation studies / tricks:
    - Impact of upstream SSL model
    - FoV
    - Resolution
    - clipping
- Conclusion

## Deep Reinforcement Learning for Sound-Driven Navigation

- Motivation:
    - Move to hear better
-
