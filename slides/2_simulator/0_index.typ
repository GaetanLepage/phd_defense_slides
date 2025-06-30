#import "/globals.typ": *

#slide(title: "", align: center + horizon)[
  #image("figures/outline.svg", height: 90%)
]

= Acoustic Robot Simulator

#slide(title: "Motivation")[
  #todo[Probably missing another figure here]

  #image("figures/reflection_types.svg")
  *Objectives:*
  - Modelling realistic acoustic environments
  - Simulating sound propagation in reverberant rooms
  - Provide high-level primitives for eperimenting with robotic auditory perception

  #pause

  *Motivations:*
  - Collecting significant amounts of data
  - Lack of holistic approaches to interactive acoustic simulation

]


#slide(align: top, title: "Room Impulse Response", composer: (4fr, 6fr))[
  #set align(left)
  #block[
    #image("figures/rir_plot.svg", height: 45%)
  ]
  #image("figures/rir_schema.svg", height: 45%)
][
  // #set text(.9em)
  *Room Impulse Response:*
  - Characterizes the reverberation properties of the room
  - Computed for each source-microphone pair
  - $T_60$ measures the reverberation level
  - Resulting signal is obtained using the RIR as a convolution filter

  #pause

  *Single source:*
  $
    y[n] = (h * x)[n]
  $

  #pause
  *Multi source:*
  $
    y[n] = sum_(i=1)^(n_s) (h_i * x_i)[n]
  $

  // #only(1)[
  //   $
  //     y[n] = (h * x)[n]
  //   $
  // ]
  // #only(2)[
  //   $
  //     y[n] = sum_(i=1)^(n_s) (h_i * x_i)[n]
  //   $
  // ]
]

#slide(title: "Existing Simulation Methods", align: top, composer: (2fr, 1fr))[

  - Numerical simulation~@botteldooren1994acoustical~@raghuvanshi2009efficient:
    $
      nabla^2 bold(p) = 1 / (c^2) (partial^2 bold(p)) / (partial t^2) " (Helmotz equation)"
    $
    #pause
  - Geometrical Acoustics
    - Ray-tracing~@cao2016interactive,
    - Image Source Model~@allen_image_1979

  #show footnote.entry: set text(size: 5pt)

  -> Generate RIR from a 3D room specification
][
  #image("figures/ray_tracing.png", height: 6em)
  #image("figures/image_source.svg", height: 6.2em)
]

#slide(title: "Audio-Processing Pipeline", repeat: 3)[
  #only(1)[
    #image("figures/audio_pipeline_1.svg")
  ]
  #only(2)[
    #image("figures/audio_pipeline_2.svg")
  ]
  #only(3)[
    #image("figures/audio_pipeline_3.svg")
  ]
  Support for two backend libraries: _PyroomAcoustics_~@scheibler2018pyroomacoustics and _gpuRIR_~@diaz2021gpurir.
]

#slide(title: "Acoustic Simulator for Robotics")[
]
#anim_slide(5, title: "Simulator Architecture", image-prefix: "/slides/2_simulator/figures/simulator_architecture_")

#slide(title: "Code Example")[
  #set text(18pt)
  ```python
  from rl_audio_nav.audio_simulator import GpuRirRoom, SquareArray, AudioSimilator

  ```
  #pause
  ```python

  # Initialization
  room = GpuRirRoom(size_x=4, size_y=7, rt_60=0.3)
  ```
  #pause
  ```python
  mic_array = SquareArray(
    position=np.array([3.0, 3.0, 1.0]),
    orientation=np.array([-1.0, 1.0, 0.0]),
  )
  ```
  #pause
  ```python
  audio_simulator = AudioSimulator(room, mic_array, n_speech_sources=3)

  ```
  #pause
  ```python
  # Load speech signals and perform simulation
  audio_simulator.step()

  ```
  #pause
  ```python
  # (4, F, T) complex tensor
  stft = audio_simulator.get_agent_stft()

  ```
  #pause
  ```python
  # Compute the DoA with respect to the "speech_1" source
  doa_source_1 = audio_simulator.get_doa("speech_1")
  ```
]

#anim_slide(3, title: "Modelling Active Scenarios", image-prefix: "/slides/2_simulator/figures/simulator_workflow_")

#slide(title: "Summary")[
  #set text(size: 1.2em)
  - Complete solution for modelling various acoustic robotics scenarios
  - High-level, intuitive API to easily and quickly build on top of
  - Extraction of various spectral representation of simulated signals
  - Great flexibility allowing for various use-cases:
    - Dataset generation
    - Modelling interactive scenarios where both microphones and sources can move
    - Use as an environment to train Deep RL agents
]
