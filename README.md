# OFDM Transceiver with Channel Estimation and Equalization

A MATLAB-based digital communication system implementing a QPSK-OFDM transceiver with pilot-based channel estimation and frequency-domain equalization over AWGN and multipath fading channels.

## Overview

Orthogonal Frequency Division Multiplexing (OFDM) is widely used in modern wireless communication systems because it provides robustness against frequency-selective channels. This project simulates an OFDM transmission and reception chain and evaluates receiver performance under different channel conditions.

## Objectives

- Implement a QPSK-modulated OFDM transceiver in MATLAB.
- Perform 64-point FFT/IFFT processing and cyclic-prefix insertion/removal.
- Simulate AWGN and multipath channel effects.
- Estimate the channel using pilot symbols and least-squares (LS) estimation with linear interpolation.
- Compare Zero-Forcing (ZF) and Minimum Mean Square Error (MMSE) equalization.
- Analyze Bit Error Rate (BER) versus Signal-to-Noise Ratio (SNR).

## System Architecture

```text
Random Data Generation
        |
    QPSK Modulation
        |
    OFDM Modulation
      IFFT (64)
        |
  Cyclic Prefix Insertion
        |
   AWGN / Multipath Channel
        |
  Cyclic Prefix Removal
        |
     FFT (64)
        |
 Pilot-Based Channel Estimation
        |
  ZF / MMSE Equalization
        |
    QPSK Demodulation
        |
   BER and SNR Analysis
```

## Key Features

- **OFDM processing:** 64-point FFT/IFFT and cyclic-prefix handling.
- **Channel modeling:** AWGN and multipath propagation.
- **Channel estimation:** Pilot-based LS estimation with linear interpolation.
- **Equalization:** Comparison of ZF and MMSE receiver approaches against a perfect-channel-knowledge baseline.
- **Performance evaluation:** BER-versus-SNR analysis and channel frequency-response visualization.

## Technologies Used

- MATLAB
- Digital Signal Processing (DSP)
- Digital Communications
- QPSK Modulation
- OFDM
- FFT/IFFT
- Channel Estimation and Equalization

## Repository Structure

```text
ofdm-transceiver-channel-estimation/
├── ofdm_transceiver.m
├── README.md
├── OFDM_Project_Report.pdf
└── results/
    ├── channel_response.png
    └── ber_vs_snr.png
```

*Update the filenames and folders to match the files actually included in your repository.*

## How to Run

1. Install MATLAB.
2. Clone or download this repository.
3. Open the project folder in MATLAB.
4. Run the main MATLAB script:

```matlab
run('ofdm_transceiver.m')
```

5. Review the generated plots and simulation results.

## Results

The simulation is designed to visualize the estimated channel frequency response and evaluate receiver performance using BER-versus-SNR curves.

Add your actual generated plots and numerical results here after validating the
