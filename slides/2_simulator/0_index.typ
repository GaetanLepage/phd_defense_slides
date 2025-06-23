#import "/globals.typ": *

= Acoustic Robot Simulator

== Motivation

Modelling realistic acoustic environments
#image("figures/reflection_types.svg")

#slide(title: "Room Impulse Response")[
  #image("figures/rir_schema.svg")
][
  *Room Impulse Response:*
  - Characterizes the reverberation properties of the room
  - $T_60$ measures the reverberation level
  - Resulting signal is obtained using the RIR as a convolution filter
  $
    y[n] = (h_r * x)[n]
  $
]

#slide(title: "Existing simulation methods")[

  - Numerical simulation:
    $
      nabla^2 bold(p) = 1 / (c^2) (partial^2 bold(p)) / (partial t^2)
    $
    #pause
  - Geometrical Acoustics
    - Ray-tracing
    - Image Source Model @allen_image_1979

  -> Generate RIR from a 3D room specification
][
  #image("figures/ray_tracing.png", width: 50%)
  #image("figures/image_source.svg", width: 50%)
]

#slide(title: "Acoustic simulator for robotics")[
  #image("figures/simulator_architecture.svg")
]

#slide(title: "Audio-processing pipeline")[
  #image("figures/audio_pipeline.svg")
]

#slide(title: "Dynamic workflow")[
  #todo[Make horizontal?]
][
  #image("figures/simulator_workflow.svg")
]

#slide(title: "Code example")[
  #set text(14pt)
  ```python
  from rl_audio_nav.audio_simulator import GpuRirRoom, SquareArray, AudioSimilator

  # Initialization
  room = GpuRirRoom(size_x=4, size_y=7, rt_60=0.3)
  mic_array = SquareArray(
    position=np.array([3.0, 3.0, 1.0]),
    orientation=np.array([-1.0, 1.0, 0.0]),
  )
  audio_simulator = AudioSimulator(room, mic_array, n_speech_sources=3)

  # Load speech signals and perform simulation
  audio_simulator.step()

  # (4, F, T) complex tensor
  stft = audio_simulator.get_agent_stft()

  # Compute the DoA with respect to the "speech_1" source
  doa_source_1 = audio_simulator.get_doa("speech_1")
  ```
]
