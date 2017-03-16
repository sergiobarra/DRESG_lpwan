%%% "Ring Network Topology (RNT) Framework" project (September 2016)
%%% Author: Sergio Barrachina (sergio.barrachina@upf.edu)

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
c = 3E8;
if model == 0 % Free space        
    d_max = (10^((P_max-S + Gtx + Grx)/20)*c)/(4*pi*f);
elseif model==1 % Urban macro deployment  (http://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=6167392)
    d_max = 10^((P_max - S - 8 -21 * log10(f/900E6) + Gtx + Grx)/37.6);
elseif model==2 % Pico/hotzone deployment 
    d_max = 10^((P_max - S - 23.3 -21 * log10(f/900E6) + Gtx + Grx)/37.6);
end

end

