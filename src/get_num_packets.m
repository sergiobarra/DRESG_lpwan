%%% "Distance-Ring Exponential Stations Generator (DRESG) for LPWANs"
%%% Author: Sergio Barrachina (sergio.barrachina@upf.edu)
%%% More info at S. Barrachina, B. Bellalta, T. Adame, and A. Bel, “Multi-hop Communication in the Uplink for LPWANs,” 
%%% arXiv preprint arXiv:1611.08703, 2016.

function [ num_packets ] = get_num_packets( num_payloads, max_pay_dfs )
    % get_num_packets() returns the number of data packets needed to be sent for a given number
    % of payloads.
    %   Arguments:
    %   - num_payloads: Num. of payload to be sent
    %   - max_pay_dfs: Max. num. of payloads that can be sent in a DFS
    %   Returned parameters:
    %   - num_dfs: Num. of DFS's

    num_packets = ceil(num_payloads / max_pay_dfs);

end

