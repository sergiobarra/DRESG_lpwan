function [ num_dfs ] = get_num_dfs( num_payloads, max_pay_dfs )
% get_num_dfs() returns the number of DFS needed to be send for a given number
%of payloads.
%   Arguments:
%   - num_payloads: Num. of payload to be sent
%   - max_pay_dfs: Max. num. of payloads that can be sent in a DFS
%   Returned parameters:
%   - num_dfs: Num. of DFS's

num_dfs = ceil(num_payloads / max_pay_dfs);

end

