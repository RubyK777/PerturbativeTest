%% function to compute LHS and RHS

function [LHS, RHS] = lhs2rhs(operators, Delta, name_of_quadratization)
% test P(3->2)-DC1, P-(3->2)DC2, P-(3->2)KKR, P(3->2)-OT, P(3->2)-CBBK, ZZZ-TI-CBBK, PSD-CBBK,
% PSD-OT, and PSD-CBBK
% operators shold be in the form of 'xyz'
%
% e.g.    [LHS, RHS] = lhs2rhs('xyz',1e10,'P(3->2)-DC2')
%         refers to quadratize x1*y2*z3 using P(3->2)-DC2 with Delta = 1e10

    if operators(1) == '-'
      operators = operators(2:end);
      coefficient = -1;
    else
      coefficient = 1;
    end
    n = length(operators);
    S = cell(n);
    x = [0 1 ; 1 0]; y = [0 -1i ; 1i 0]; z = [1 0 ; 0 -1];

    if strcmp(name_of_quadratization, 'P(3->2)-DC2') || strcmp(name_of_quadratization, 'P(3->2)DC2')
        assert(n == 3, 'P(3->2)-DC2 requires a 3-local term, please only give 3 operators.');
        for ind = 1:n
            if operators(ind) == 'x'
                S{ind} = kron(kron(eye(2^(ind-1)),x),eye(2^(n+1-ind)));
            elseif operators(ind) == 'y'
                S{ind} = kron(kron(eye(2^(ind-1)),y),eye(2^(n+1-ind)));
            elseif operators(ind) == 'z'
                S{ind} = kron(kron(eye(2^(ind-1)),z),eye(2^(n+1-ind)));
            end
        end
        xa = kron(eye(8),x); za = kron(eye(8),z);

        alpha = (1/2)*Delta;
        alpha_s = coefficient*((1/4)*(Delta^(2/3)) - 1);
        alpha_z = (1/2)*Delta;
        alpha_ss = Delta^(1/3);
        alpha_sz = coefficient*(1/4)*(Delta^(2/3));
        alpha_sx = Delta^(2/3);

        LHS = coefficient*S{1}*S{2}*S{3};
        RHS = alpha*eye(16) + alpha_s*S{3} + alpha_z*za + alpha_ss*((S{1} + S{2})^2) + alpha_sx*(S{1}*xa + S{2}*xa) + alpha_sz*za*S{3};

    elseif strcmp(name_of_quadratization, 'P(3->2)-KKR') || strcmp(name_of_quadratization, 'P(3->2)KKR')
        assert(n == 3, 'P(3->2)-KKR requires a 3-local term, please only give 3 operators.');
        for ind = 1:n
            if operators(ind) == 'x'
                S{ind} = kron(kron(eye(2^(ind-1)),x),eye(2^(n+3-ind)));
            elseif operators(ind) == 'y'
                S{ind} = kron(kron(eye(2^(ind-1)),y),eye(2^(n+3-ind)));
            elseif operators(ind) == 'z'
                S{ind} = kron(kron(eye(2^(ind-1)),z),eye(2^(n+3-ind)));
            end
        end
        xa1 = kron(kron(eye(8),x),eye(4)); xa2 = kron(kron(eye(16),x),eye(2)); xa3 = kron(eye(32),x);
        za1 = kron(kron(eye(8),z),eye(4)); za2 = kron(kron(eye(16),z),eye(2)); za3 = kron(eye(32),z);

        alpha = -(1/8)*(Delta);
        alpha_ss = -(1/6)*(Delta)^(1/3);
        alpha_sx = (1/6)*(Delta)^(2/3);
        alpha_zz = (1/24)*(Delta);
 %      have not add coefficient
        LHS = S{1}*S{2}*S{3};
        RHS = alpha*eye(2^(n+3)) + alpha_ss*(S{1}^2 + S{2}^2 + S{3}^2) + alpha_sx*(S{1}*xa1 + S{2}*xa2 + S{3}*xa3) + alpha_zz*(za1*za2 + za1*za3 + za2*za3);

    elseif strcmp(name_of_quadratization, 'P(3->2)KKR-A') % no coefficient needed
        assert(n == 3, 'P(3->2)KKR-A requires a 3-local term, please only give 3 operators.');
        assert(isequal(coefficient,1), 'Cannot change the coefficient of P(3->2)KKR-A');
        for ind = 1:n
            if operators(ind) == 'x'
                S{ind} = kron(kron(eye(2^(ind-1)),x),eye(2^(n+3-ind)));
            elseif operators(ind) == 'y'
                S{ind} = kron(kron(eye(2^(ind-1)),y),eye(2^(n+3-ind)));
            elseif operators(ind) == 'z'
                S{ind} = kron(kron(eye(2^(ind-1)),z),eye(2^(n+3-ind)));
            end
        end
        xa1 = kron(kron(eye(8),x),eye(4)); xa2 = kron(kron(eye(16),x),eye(2)); xa3 = kron(eye(32),x);
        za1 = kron(kron(eye(8),z),eye(4)); za2 = kron(kron(eye(16),z),eye(2)); za3 = kron(eye(32),z);

        alpha = (3/4)*(Delta);
        alpha_ss = (Delta)^(1/3);
        alpha_sx = -(Delta)^(2/3);
        alpha_zz = -(1/4)*(Delta);

        LHS = -6*S{1}*S{2}*S{3};
        RHS = alpha*eye(64) + 3*alpha_ss*eye(64) + alpha_sx*(S{1}*xa1 + S{2}*xa2 + S{3}*xa3) + alpha_zz*(za1*za2 + za1*za3 + za2*za3);

    elseif strcmp(name_of_quadratization, 'P(3->2)-DC1') || strcmp(name_of_quadratization, 'P(3->2)DC1')
        assert(n == 3, 'P(3->2)-DC1 requires a 3-local term, please only give 3 operators.');
        for ind = 1:n
            if operators(ind) == 'x'
                S{ind} = kron(kron(eye(2^(ind-1)),x),eye(2^(n+3-ind)));
            elseif operators(ind) == 'y'
                S{ind} = kron(kron(eye(2^(ind-1)),y),eye(2^(n+3-ind)));
            elseif operators(ind) == 'z'
                S{ind} = kron(kron(eye(2^(ind-1)),z),eye(2^(n+3-ind)));
            end
        end
        xa1 = kron(kron(eye(8),x),eye(4)); xa2 = kron(kron(eye(16),x),eye(2)); xa3 = kron(eye(32),x);
        za1 = kron(kron(eye(8),z),eye(4)); za2 = kron(kron(eye(16),z),eye(2)); za3 = kron(eye(32),z);

        alpha = (1/8)*Delta;
        alpha_ss = (1/6)*(Delta)^(1/3);
        alpha_sx = (-1/6)*(Delta)^(2/3);
        alpha_zz = (-1/24)*Delta;
%       have not add coefficient
        LHS = S{1}*S{2}*S{3};
        RHS = alpha*eye(2^(n+3)) + alpha_ss*(S{1}^2 + S{2}^2 + S{3}^2) + alpha_sx*(S{1}*xa1 + S{2}*xa2 + S{3}*xa3) + alpha_zz*(za1*za2 + za1*za3 + za2*za3);

   elseif strcmp(name_of_quadratization, 'ZZZ-TI-CBBK')
        assert(n == 3, 'ZZZ-TI-CBBK requires a 3-local term, please only give 3 operators.');
        for ind = 1:n
            assert(operators(ind) == 'z', 'ZZZ-TI-CBBK requires a ZZZ term.');
            S{ind} = kron(kron(eye(2^(ind-1)),z),eye(2^(n+1-ind)));
        end

        xa = kron(eye(8),x);
        za = kron(eye(8),z);

        alpha_I = (1/2)*(Delta + ((coefficient/6)^(2/5))*(Delta^(3/5)) + 6*((coefficient/6)^(4/5))*(Delta^(1/5)) );
        alpha_zi = (-1/2)*(( ((7/6)*coefficient) + ( ((coefficient/6)^(3/5))*(Delta^(2/5))) ) - ( (coefficient/6)*(Delta^4) )^(1/5));
        alpha_zj = alpha_zi;
        alpha_zk = alpha_zi;
        alpha_za = (-1/2)*( Delta - (((coefficient/6)^(2/5))*(Delta^(3/5))) );
        alpha_xa = ( (coefficient/6)*(Delta^4) )^(1/5);
        alpha_zzia = (-1/2)*( ( (7/6)*coefficient + ((coefficient/6)^(3/5))*(Delta^(2/5)) ) + ( (coefficient/6)*(Delta^4) )^(1/5) );
        alpha_zzja = alpha_zzia;
        alpha_zzka = alpha_zzja;
        alpha_zzij = 2*((coefficient/6)^(4/5))*((Delta)^(1/5));
        alpha_zzik = alpha_zzij;
        alpha_zzjk = alpha_zzij;

        LHS = S{1}*S{2}*S{3};
        RHS = alpha_I*eye(16) + alpha_zi*S{1} + alpha_zj*S{2} + alpha_zk*S{3} + alpha_za*za + alpha_xa*xa + alpha_zzia*S{1}*za + alpha_zzja*S{2}*za + alpha_zzka*S{3}*za + alpha_zzij*S{1}*S{2} + alpha_zzik*S{1}*S{3} + alpha_zzjk*S{2}*S{3};

    elseif strcmp(name_of_quadratization, 'PSD-CBBK')
        assert(n >= 5, 'PSD-CBBK requires at least a 5-local term, please give at least 5 operators.');
        for ind = 1:n
            if operators(ind) == 'x'
                S{ind} = kron(kron(eye(2^(ind-1)),x),eye(2^(n+1-ind)));
            elseif operators(ind) == 'y'
                S{ind} = kron(kron(eye(2^(ind-1)),y),eye(2^(n+1-ind)));
            elseif operators(ind) == 'z'
                S{ind} = kron(kron(eye(2^(ind-1)),z),eye(2^(n+1-ind)));
            end
        end

        n_a = ceil(n/2);

        A = eye(2^(n+1)); B = eye(2^(n+1));
        for ind = 1:n_a
            A = A*S{ind};
        end

        for ind = n_a + 1:n
            B = B*S{ind};
        end
        za = kron(eye(2^n),z);
        xa = kron(eye(2^n),x);

        LHS = coefficient*A*B;
        RHS = (Delta)*((1*eye(2^(n+1)) - za)/2) + abs(coefficient)*((1*eye(2^(n+1)) + za)/2) + sqrt( abs(coefficient)*Delta/2 )*(sign(coefficient)*A - B)*xa;

    elseif strcmp(name_of_quadratization, 'PSD-OT')
        assert(n >= 4, 'PSD-OT requires at least a 4-local term, please give at least 4 operators.');
        for ind = 1:n
            if operators(ind) == 'x'
                S{ind} = kron(kron(eye(2^(ind-1)),x),eye(2^(n+1-ind)));
            elseif operators(ind) == 'y'
                S{ind} = kron(kron(eye(2^(ind-1)),y),eye(2^(n+1-ind)));
            elseif operators(ind) == 'z'
                S{ind} = kron(kron(eye(2^(ind-1)),z),eye(2^(n+1-ind)));
            end
        end

        A = eye(2^(n+1)); B = eye(2^(n+1));
        n_a = ceil(n/2);

        for ind = 1:n_a
            A = A*S{ind};
        end

        for ind = n_a + 1:n
            B = B*S{ind};
        end
        za = kron(eye(2^n),z);
        xa = kron(eye(2^n),x);

        LHS = coefficient*A*B;
        RHS = Delta*((1*eye(2^(n+1)) - za)/2) + (coefficient/2)*(A^2 + B^2) + sqrt( coefficient*Delta/2 )*(-A + B)*xa;

    elseif strcmp(name_of_quadratization, 'P(3->2)CBBK') || strcmp(name_of_quadratization, 'P(3->2)-CBBK')
        assert(n == 3, 'P(3->2)-CBBK requires a 3-local term, please only give 3 operators.');
        for ind = 1:n
            if operators(ind) == 'x'
                S{ind} = kron(kron(eye(2^(ind-1)),x),eye(2^(n+1-ind)));
            elseif operators(ind) == 'y'
                S{ind} = kron(kron(eye(2^(ind-1)),y),eye(2^(n+1-ind)));
            elseif operators(ind) == 'z'
                S{ind} = kron(kron(eye(2^(ind-1)),z),eye(2^(n+1-ind)));
            end
        end

        za = kron(eye(8),z);
        xa = kron(eye(8),x);

        alpha = Delta/2 + (1/2)*(coefficient/2)^(2/3)*Delta^(1/2)*( (sign(coefficient)^2) + 1 ) - (sign(coefficient)^2)*((coefficient/2)^(4/3))* ((sign(coefficient)^2) + 1);
        alpha_s3 = (1/2)*(coefficient/2)^(1/3)*(Delta^(1/2)) - (coefficient/4)*( (sign(coefficient)^2) + 1 );
        alpha_za = (-Delta/2) + (1/2)*(coefficient/2)^(2/3)*Delta^(1/2)*( (sign(coefficient)^2) + 1 ) - (sign(coefficient)^2)*((coefficient/2)^(4/3))* ((sign(coefficient)^2) + 1);
        alpha_s1_s2 = 2*sign(coefficient)*((coefficient/2)^(2/3))*(Delta^(1/2)) - 4*sign(coefficient)*((coefficient/2)^(4/3));
        alpha_s3_za = (-1/2)*(coefficient/2)^(1/3)*(Delta^(1/2)) - (coefficient/4)*( (sign(coefficient)^2) + 1 );
        alpha_s1_xa = sign(coefficient)*(coefficient/2)^(1/3)*(Delta^(3/4));
        alpha_s2_xa = (coefficient/2)^(1/3)*(Delta^(3/4));

        LHS = coefficient*S{1}*S{2}*S{3};
        RHS = alpha*eye(16) + alpha_s3*S{3} + alpha_za*za + alpha_s3_za*S{3}*za ...
            + alpha_s1_xa*S{1}*xa + alpha_s2_xa*S{2}*xa + alpha_s1_s2*S{1}*S{2};

    elseif strcmp(name_of_quadratization, 'P(3->2)-OT') || strcmp(name_of_quadratization, 'P(3->2)OT')
        assert(n == 3, 'P(3->2)-OT requires a 3-local term, please only give 3 operators.');
        for ind = 1:n
            if operators(ind) == 'x'
                S{ind} = kron(kron(eye(2^(ind-1)),x),eye(2^(n+1-ind)));
            elseif operators(ind) == 'y'
                S{ind} = kron(kron(eye(2^(ind-1)),y),eye(2^(n+1-ind)));
            elseif operators(ind) == 'z'
                S{ind} = kron(kron(eye(2^(ind-1)),z),eye(2^(n+1-ind)));
            end
        end

        za = kron(eye(8),z);
        xa = kron(eye(8),x);

        alpha = (Delta/2);
        alpha_s1 = ((Delta^(1/3))*(coefficient^(2/3))/2);
        alpha_s2 = ((Delta^(1/3))*(coefficient^(2/3))/2);
        alpha_s3 = -((Delta^(2/3))*(coefficient^(1/3))/2);
        alpha_za = -(Delta/2);

        alpha_s1_s2 = -((Delta^(1/3))*(coefficient^(2/3)));
        alpha_s1_s3 = (coefficient/2);
        alpha_s2_s3 = (coefficient/2);

        alpha_s3_za = (Delta^(2/3))*(coefficient^(1/3)/2);

        alpha_s1_xa = -((Delta^(2/3))*(coefficient^(1/3))/sqrt(2));
        alpha_s2_xa = ((Delta^(2/3))*(coefficient^(1/3))/sqrt(2));

        LHS = coefficient*S{1}*S{2}*S{3};
        RHS = alpha*eye(16) + alpha_s1*(S{1})^2 + alpha_s2*(S{2})^2 + alpha_s3*S{3} ...
        + alpha_za*za + alpha_s1_s2*S{1}*S{2} + alpha_s1_s3*(S{1}^2)*S{3} + alpha_s2_s3*(S{2}^2)*S{3} + alpha_s3_za*S{3}*za ...
        + alpha_s1_xa*S{1}*xa + alpha_s2_xa*S{2}*xa;
    else
        disp('cannot find this method');
        LHS = []; RHS = [];
    end
end

%% Delta test

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
