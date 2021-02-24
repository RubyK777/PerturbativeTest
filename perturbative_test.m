delta_required = zeros(7,1); tol = 1e-03; k = 1;    % fundamental settings where k is the number of auxiliary qubit
for Delta = 1e10:1e10:1e13
[LHS,RHS] = lhs2rhs('xxx',Delta,'P(3->2)CBBK');
[V_RHS,E_RHS] = eig(RHS);
[V_LHS,E_LHS] = eig(LHS);
E_RHS = sort(diag(E_RHS));
E_LHS = sort(diag(E_LHS));
[ind_evals_L, ind_evals_R] = find( abs(E_RHS'-E_LHS) < tol );              % indices of LHS and RHS where eigenvalues match within tol
if isempty(ind_evals_L) == 0        % matching eigenvalues exist
    L = V_LHS(:,ind_evals_L);                                                   % L = LHS eigenvectors for eigenvalues matching RHS
    R = V_RHS(:,ind_evals_R);
    ind_evecs = find( sqrt(sum( (abs(L)-abs(R)).^2 ) ) < tol);
    [sorted_L,index] = unique(L(:,ind_evecs)','rows','first');
    sorted_L = sorted_L(index,:)';
    [sorted_R,index] = unique(R(:,ind_evecs)','rows','first');
    sorted_R = sorted_R(index,:)';                                    % remove repeated eigenvectors while maintaining the order
    if (sum( abs(E_LHS(1:2^k) - E_RHS(1)) < tol ) == 2^k)
            if (delta_required(1) == 0)
                delta_required(1) = Delta;  % value of Delta that let ground energy match
            end
            if (isempty(ind_evecs) == 0) && (delta_required(2) == 0)
                delta_required(2) = Delta;  % value of Delta that let ground state match
            end

            if (sum( abs(E_LHS((2^k + 1):2^(k+1)) - E_RHS(2)) < tol ) == 2^k)
                if (delta_required(3) == 0)
                    delta_required(3) = Delta;  % value of Delta that let first excited energy match
                end

                if (size(sorted_L,2) >= 2) && (delta_required(4) == 0)
                    delta_required(4) = Delta;   % value of Delta that let first excited state match
                end
            end

            if (numel(unique(ind_evals_R)) == 8)
                if (delta_required(5) == 0)
                delta_required(5) = Delta;   % value of Delta that let all 8 energies match
                end

                if isequal(size(sorted_L,2),size(sorted_R,2),8) && (delta_required(6) == 0)
                    delta_required(6) = Delta;  % value of Delta that let all 8 states match
                end
            end
    end
end
if ne(delta_required(5),0) && ne(delta_required(6),0) && (delta_required(7) == 0) && (numel(unique(ind_evals_R)) == 0)
    delta_required(7) = Delta;  % value of Delta that is too large to keep energies matching
end
end
delta_required(delta_required == 0) = nan;
quit
