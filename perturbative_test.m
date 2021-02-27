% fundamental settings for testing multiple Delta values, where k is the number of auxiliary qubits
name_of_quadratization = 'P(3->2)DC2'; Delta_lower_bound = 1e12; Delta_increment = 1e10;
Delta_upper_bound = 1e13;  tol = 1e-06; k = 1;

combinations = cell(27,1); S{1} = 'x'; S{2} = 'y'; S{3} = 'z'; n_combination = 1;  % fundamental settings for testing multiple combinations
combined_delta_required = zeros(6,27);             % the desired Delta values for different s1s2s3 combinations

for s1 = 1:3
for s2 = 1:3
for s3 = 1:3
    combinations(n_combination) = {['-' S{s1} S{s2} S{s3}]};         % the order of terms being tested
    % get the disired delta values for a certain combination
    delta_required = GetReqdDelta(['-' S{s1} S{s2} S{s3}],Delta_lower_bound,Delta_increment,Delta_upper_bound,name_of_quadratization,tol,k);
    combined_delta_required(:,n_combination) = delta_required;
    delta_required = [];                % clear the array
    n_combination = n_combination + 1;
end
end
end

combinations
combined_delta_required       % gives combinations and corresponding delta_required as outputs
