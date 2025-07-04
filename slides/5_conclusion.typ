#import "/globals.typ": *

= Conclusion

#slide(title: "Summary of Contributions")[

  + Design and implementation of an holistic *simulation library* for modelling audio-based interactions.
    #pause
  + Extensive experimental studies of deep-learning-based methods solving two variations of the *static SSL* problem.
    #pause
  + Design and experimental evaluation of a novel deep-learning-based solution to an *active multi-source localization* problem.
    #pause
  + Introduction of a perceptually-motivated robotic navigation task.\
    Training and evaluation of Deep-RL agent solving this task.
]

#slide(title: "Main Limitations")[

  - Study *limited to simulated environments*. Transferring algorithms trained in virtual environments to real robots is a challenging, yet necessary endeavour.\
    #pause
  - Task and agent constraints. Several *simplifying assumptions* were made in the different tasks.\
    - Static sources,
    - Simplistic robot acoustic modelling: free-field microphone array (no HRTF)
    - Limitation to 2D geometric settings: no consideration for the elevation component
    Targetting more challenging and realistic problem formulations would improve the overall relevance of the proposed methods.
    #pause
  - *Engineering and algorithmic challenges:*
    - The RL agent's training is expensive, and tedious.
      Numerous engineering considerations are required to ensure a successful policy learning.
    - Relying on pre-computed WER cost maps allows the RL environment to run at a high refresh rate, but doesn't easily scale to multiple moving sources.
]

#slide(title: "Perspectives")[

  // TODO: capitalization
  - *Embodied and multimodal audio perception:*\
    - Combine auditory signals with visual cues to leverage social robots' sensors diversity.
    #pause
  - *Active perception beyond localization:*\
    - Explore other navigation objectives: speaker-following, audio-based exploration, information-seeking policy, etc.
    #pause
  - *Model efficiency and generalization:*\
    - Investigate RL agents' lack of generalization.\
    - Solve more diverse and challenging MDPs (changing room geometries, moving sources, noisy conditions, etc.)
]
