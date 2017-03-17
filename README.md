# DRESG framework for LPWANs

The Distance-Ring Exponential Stations Generator (DRESG) allows analyzing the impact on LPWANs energy consumption of multi-hop communication in the uplink. By letting STAs to transmit data packets in lower power levels and higher data rates to closer parent STAs, they normally reduce their energy consumption consequently.

DRESG is a framework developed in Matlab designed to evaluate the performance of the so-called optimal-hop routing model, which establishes optimal routing connections in terms of energy efficiency, aiming to balance the consumption among all the STAs in the network. Results show that enabling such multi-hop connections entails higher network lifetimes, reducing significantly the bottleneck consumption in LPWANs with up to thousands of STAs. These results lead to foresee multi-hop communication in the uplink as a promising routing alternative for extending the lifetime of LPWAN deployments. A detailed analysis of the consumption of multi-hop in the uplink for LPWANs can be found in *[S. Barrachina, B. Bellalta, T. Adame, and A. Bel, “Multi-hop Communication in the Uplink for LPWANs,” arXiv preprint arXiv:1611.08703, 2016](https://arxiv.org/pdf/1701.04673.pdf)*.  

### Installation

Just [Matlab](https://www.mathworks.com/) is required.

### Usage
 
 * Set the scenario configuration and DRESG deployment in file "set_configuration.m". 
 * Run main file "main_analysis.m" to display the analysis results.

### Support
You can contact me for any issue you may have when using DRESG.

### Contributing
I am always open to new contributions :) Just drop me an email at sergio.barrachina@upf.edu