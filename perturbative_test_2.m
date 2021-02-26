%% Delta test

delta_required = zeros(7,27); combinations = cell(27,1); tol = 1e-03; k = 1;
S{1} = 'x'; S{2} = 'y'; S{3} = 'z'; n_combination = 1;   % fundamental settings where k is the number of auxiliary qubit, n_combinations is the number of combination

for s1 = 1:3
for s2 = 1:3
for s3 = 1:3
    for Delta = 1e5:1e5:1e10
    combinations(n_combination) = {[S{s1} S{s2} S{s3}]};     % terms that being tested
    [LHS,RHS] = lhs2rhs([S{s1} S{s2} S{s3}],Delta,'P(3->2)CBBK');
    if isnan(RHS) == 0
      [V_RHS,E_RHS] = eig(RHS);
      [V_LHS,E_LHS] = eig(LHS);
      [E_RHS,index] = sort(diag(E_RHS)); V_RHS = V_RHS(:,index);
      [E_LHS,index] = sort(diag(E_LHS)); V_LHS = V_LHS(:,index);
      [ind_evals_L, ind_evals_R] = find( abs(E_RHS'-E_LHS) < tol );              % indices of LHS and RHS where eigenvalues match within tol
      if isempty(ind_evals_L) == 0        % matching eigenvalues exist
          L = V_LHS(:,ind_evals_L);                                                   % L = LHS eigenvectors for eigenvalues matching RHS
          R = V_RHS(:,ind_evals_R);
          ind_evecs = find( sqrt(sum( (abs(L)-abs(R)).^2 ) ) < tol);
          L = L(:,ind_evecs);
          [~,index] = unique(L','rows','first');
          sorted_L = L(:,sort(index));                                            % remove repeated eigenvectors while maintaining the order
          R = R(:,ind_evecs);
          sorted_R = R(:,sort(index));
          if (sum( abs(E_LHS(1:2^k) - E_RHS(1)) < tol ) == 2^k)
              if (delta_required(1,n_combination) == 0)
                  delta_required(1,n_combination) = Delta;  % value of Delta that let ground energy match
              end
              if (isempty(ind_evecs) == 0) && (delta_required(2,n_combination) == 0)
                  delta_required(2,n_combination) = Delta;  % value of Delta that let ground state match
              end

              if (sum( abs(E_LHS((2^k + 1):2^(k+1)) - E_RHS(2)) < tol ) == 2^k)
                  if (delta_required(3,n_combination) == 0)
                      delta_required(3,n_combination) = Delta;  % value of Delta that let first excited energy match
                  end

                  if (size(sorted_L,2) >= 2) && (delta_required(4,n_combination) == 0)
                      delta_required(4,n_combination) = Delta;   % value of Delta that let first excited state match
                  end
              end

              if (numel(unique(ind_evals_R)) == 8)
                  if (delta_required(5,n_combination) == 0)
                    delta_required(5,n_combination) = Delta;   % value of Delta that let all 8 energies match
                  end

                  if isequal(size(sorted_L,2),size(sorted_R,2),8) && (delta_required(6,n_combination) == 0)
                      delta_required(6,n_combination) = Delta;  % value of Delta that let all 8 states match
                  end
              end
        end
        if ne(delta_required(5,n_combination),0) && ne(delta_required(6,n_combination),0) && (delta_required(7,n_combination) == 0) && (numel(unique(ind_evals_R)) == 0)
          delta_required(7,n_combination) = Delta;  % value of Delta that is too large to keep energies matching
        end
      end
    end
    end
    n_combination = n_combination + 1;
end
end
end
delta_required(delta_required == 0) = nan;
combinations
delta_required       % get combinations and delta_required as outputs
