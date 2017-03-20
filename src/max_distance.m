%%% "Distance-Ring Exponential Stations Generator (DRESG) for LPWANs"
%%% Author: Sergio Barrachina (sergio.barrachina@upf.edu)
%%% More info at S. Barrachina, B. Bellalta, T. Adame, and A. Bel, “Multi-hop Communication in the Uplink for LPWANs,” 
%%% arXiv preprint arXiv:1611.08703, 2016.
%%%
%%% File description: function for computing the maximum communication
%%% distance.

function [ d_max ] = max_distance(model, P_max, Grx, Gtx, S, f)
%MAX_DISTANCE Returns de max distance given a maximum power transmission
    %   Arguments:
    %   - model: propagation model (0: free-space, 1:...)
    %   - P_max: max transmission power [dBm]
    %   - Grx: receiver gain [dBi]
    %   - Gtx: transmitter gaint [dBi]
    %   - S: sensitivity [bps]
    %   - f: frequency [Hz]
    %   Returned parameters:
    %   - d_max: Max distance reachable [m]
    
    PROPAGATION_MODEL_FREE_SPACE = 0;   % Free space propagation model
    PROPAGATION_MODEL_URBAN_MACRO = 1;  % 802.11 Urban macro deployment propagation model
    PROPAGATION_MODEL_PICO = 2;         % 802.11 Pico/hotzone propagation model
   
    c = 3E8;

    switch model
        case PROPAGATION_MODEL_FREE_SPACE   % Free space 
            d_max = (10^((P_max - S + Gtx + Grx)/20)*c)/(4*pi*f);
        case PROPAGATION_MODEL_URBAN_MACRO  % Urban macro deployment  (http://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=6167392)
            d_max = 10^((P_max - S - 8 -21 * log10(f/900E6) + Gtx + Grx)/37.6);
        case PROPAGATION_MODEL_PICO         % Pico/hotzone deployment 
            d_max = 10^((P_max - S - 23.3 -21 * log10(f/900E6) + Gtx + Grx)/37.6);
        otherwise
            error('Unkown propagation model!')
    end
    
end

