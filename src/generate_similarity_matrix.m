load('configuration.mat')

disp('Computing action similarity matrix (be patient my friend)...')
% Create action similarity matrix
num_possible_arms = size(delta_combinations, 1);
similarity_matrix = zeros(num_possible_arms, num_possible_arms);

for i = 1 : num_possible_arms

    for j = 1 : num_possible_arms

        action_distance = sum(abs(delta_combinations(i,:) - delta_combinations(j,:)));
        similarity_matrix(i, j) = action_distance; 

    end
end

similarity_matrix_file = strcat('similarity_matrix_r',num2str(num_rings),'.mat');
save(similarity_matrix_file, 'similarity_matrix')