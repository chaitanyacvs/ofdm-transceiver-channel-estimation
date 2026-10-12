# OFDM Transceiver with Channel Estimation and Equalization

A MATLAB-based digital communications project implementing a QPSK-OFDM transceiver with pilot-based channel estimation and frequency-domain equalization over AWGN and multipath channels.

## Overview

Orthogonal Frequency Division Multiplexing (OFDM) is a multicarrier modulation technique used in wireless communication systems. This project simulates an OFDM transmission and reception chain to study channel estimation, equalization, and receiver performance under different signal-to-noise ratio (SNR) conditions.

The implementation includes a 64-point FFT/IFFT, cyclic-prefix processing, pilot-based least-squares (LS) channel estimation, linear interpolation, and Zero-Forcing (ZF) and Minimum Mean Square Error (MMSE) equalization.

## Objectives

- Develop a QPSK-based OFDM transceiver in MATLAB.
- Implement 64-point FFT/IFFT processing and cyclic-prefix insertion/removal.
- Simulate AWGN and multipath channel effects.
- Estimate the channel using pilot symbols and LS estimation.
- Apply linear interpolation to estimate the channel response across subcarriers.
- Compare ZF and MMSE equalization against a perfect-channel-knowledge ZF reference.
- Evaluate receiver performance using BER-versus-SNR analysis.

## System Architecture

```text
Random Information Bits
          |
     QPSK Modulation
          |
    OFDM Subcarrier Mapping
          |
        IFFT (64)
          |
  Cyclic Prefix Insertion
          |
    Multipath Channel
       + AWGN Noise
          |
  Cyclic Prefix Removal
          |
         FFT (64)
          |
  Pilot-Based LS Estimation
          |
   Linear Interpolation
          |
    Frequency-Domain
       Equalization
      /      |       \
     ZF    MMSE    Perfect CSI
      \      |       /
       QPSK Demodulation
              |
        BER Calculation
              |
       Performance Plots
```

## System Configuration

| Parameter | Configuration |
|---|---|
| Programming environment | MATLAB |
| Modulation | QPSK |
| FFT/IFFT size | 64 |
| Cyclic prefix | 16 samples |
| OFDM symbols | 2,000 |
| Pilot arrangement | Every fourth subcarrier |
| Pilot estimation | Least Squares (LS) |
| Interpolation | Linear |
| Channel model | Three-tap static multipath |
| Noise model | Additive White Gaussian Noise (AWGN) |
| SNR sweep | 0–24 dB, in 2 dB steps |
| Equalization | ZF and MMSE |
| Reference | Perfect channel knowledge with ZF |

## Key Features

### 1. QPSK-OFDM Transceiver

- Generates random information bits and maps them to QPSK symbols.
- Maps data and known pilot symbols onto OFDM subcarriers.
- Performs IFFT-based OFDM modulation.
- Adds a cyclic prefix to each OFDM symbol.

### 2. Multipath and AWGN Channel Modeling

- Models a three-tap complex-valued multipath channel.
- Adds complex AWGN at different SNR values.
- Uses cyclic-prefix removal before FFT-based demodulation.

### 3. Pilot-Based Channel Estimation

- Estimates the channel at known pilot locations using LS estimation.
- Applies linear interpolation to estimate the channel response across subcarriers.
- Compares the estimated channel magnitude with the true channel response.

### 4. Frequency-Domain Equalization

- Implements Zero-Forcing (ZF) equalization.
- Implements MMSE equalization using a noise-dependent regularization term.
- Includes a perfect-channel-knowledge ZF reference for comparison.

### 5. BER Performance Analysis

- Sweeps SNR from 0 dB to 24 dB.
- Calculates BER by comparing transmitted and detected bits.
- Generates a BER comparison plot for the implemented receiver methods.

## Simulation Results

The following PDFs contain the generated simulation outputs.

### Channel Estimation

Shows pilot-based LS channel estimates and the interpolated channel response.

[**View Channel Estimation Results (PDF)**](Channel%20Estimation.pdf)

### Channel Frequency Response

Visualizes the channel frequency response across OFDM subcarriers.

[**View Channel Frequency Response (PDF)**](Channel%20Frequency%20Response.pdf)

### OFDM Equalizer BER Comparison

Compares BER performance for pilot-based ZF, pilot-based MMSE, and the perfect-channel-knowledge ZF reference.

[**View OFDM Equalizer BER Comparison (PDF)**](OFDM%20Equalizer%20BER%20Comparison.pdf)

### Complete Project Report

The report describes the system configuration, transmitter and receiver processing, channel estimation, equalization, performance evaluation, limitations, and possible future improvements.

[**View Complete Project Report (PDF)**](OFDM_Project_Report.pdf)

## Repository Structure

```text
ofdm-transceiver-channel-estimation/
├── README.md
├── LICENSE
├── ofdm_transceiver.m
├── OFDM_Project_Report.pdf
├── Channel Estimation.pdf
├── Channel Frequency Response.pdf
└── OFDM Equalizer BER Comparison.pdf
```

## How to Run

1. Install MATLAB.
2. Clone or download this repository.
3. Open MATLAB and navigate to the repository directory.
4. Run the main script:

```matlab
run('ofdm_transceiver.m')
```

5. Review the generated simulation plots.

The filename above matches the MATLAB source file currently shown in the repository. If the script or its dependencies change, update these instructions accordingly.

## Technologies and Concepts

- MATLAB
- Digital Signal Processing (DSP)
- Digital Communications
- QPSK Modulation
- Orthogonal Frequency Division Multiplexing (OFDM)
- FFT/IFFT Processing
- Cyclic Prefix
- AWGN and Multipath Channel Modeling
- Pilot-Based LS Channel Estimation
- Zero-Forcing and MMSE Equalization
- BER and SNR Analysis

## Limitations

- The channel is static; Doppler and time-varying channel effects are not modeled.
- Carrier-frequency offset and synchronization errors are not modeled.
- Channel estimation uses linear interpolation, which may not be optimal for all channel profiles.
- Quantitative BER conclusions depend on consistent SNR and noise-variance definitions.
- This is a MATLAB simulation project; it does not claim a completed RTL implementation or FPGA deployment.
- The project does not claim compliance with a specific 5G NR standard.

## Future Improvements

- Add Doppler and carrier-frequency-offset modeling.
- Investigate synchronization and compensation techniques.
- Compare alternative pilot patterns and channel-estimation methods.
- Validate noise normalization and report measured BER results.
- Explore fixed-point modeling and RTL implementation of selected receiver blocks.

## Author

**Chaitanya Chintalapati**

B.E. Electronics and Communication Engineering  
Chaitanya Bharathi Institute of Technology (CBIT), Hyderabad

## License

This project is distributed under the license included in this repository. See the [LICENSE](LICENSE) file for details.
