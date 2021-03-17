function [LHS, RHS] = lhs2rhs(coefficient,S,NeededM,Delta, name_of_quadratization)
% test P(3->2)-DC1, P-(3->2)DC2, P-(3->2)KKR, P(3->2)-OT, P(3->2)-CBBK, ZZZ-TI-CBBK,
% P1B1-OT, P1B1-CBBK, PSD-OT, PSD-CBBK, and PSD-CN
% S needs to be defined before using this function, and it should be a cell array in which S{1} is a matrix of an operator
% NeededM needs to be defined before using this function, and it should be a cell array that contains matrices of auxiliary operators, identity matrix needed, and LHS
%
% e.g.    S = [S1; S2; S3];
%         [LHS, RHS] = lhs2rhs(-1,S,1e10,'P(3->2)-DC2')
%         refers to quadratize -S1*S2*S3 using P(3->2)-DC2 with Delta = 1e10


    n = size(S,1);      % number of operators

    if strcmp(name_of_quadratization, 'P(3->2)-DC2') || strcmp(name_of_quadratization, 'P(3->2)DC2')
        assert(n == 3, 'P(3->2)-DC2 requires a 3-local term, please only give 3 operators.');

        xa = NeededM{1}; za = NeededM{2}; I = NeededM{3};
        S1 = S{1}; S2 = S{2}; S3 = S{3};

        alpha = (1/2)*Delta;
        alpha_s = coefficient*((1/4)*(Delta^(2/3)) - 1);
        alpha_z = (1/2)*Delta;
        alpha_ss = Delta^(1/3);
        alpha_sz = coefficient*(1/4)*(Delta^(2/3));
        alpha_sx = Delta^(2/3);

        LHS = NeededM{end};
        RHS = alpha*I + alpha_s*S3 + alpha_sx*xa*S1 + alpha_sx*xa*S2 + alpha_sz*za*S3 + alpha_z*za + 2*alpha_ss*I + 2*alpha_ss*S1*S2;        % we only use x,y,z here, for which S^2 = I
        % original RHS = alpha*eye(16) + alpha_s*S3 + alpha_sx*xa*S1 + alpha_sx*xa*S2 + alpha_sz*za*S3 + alpha_z*za + alpha_ss*((S1 + S2)^2);

    elseif strcmp(name_of_quadratization, 'P(3->2)-KKR') || strcmp(name_of_quadratization, 'P(3->2)KKR')
        assert(n == 3, 'P(3->2)-KKR requires a 3-local term, please only give 3 operators.');

        xa1 = kron(kron(eye(8),x),eye(4)); xa2 = kron(kron(eye(16),x),eye(2)); xa3 = kron(eye(32),x);
        za1 = kron(kron(eye(8),z),eye(4)); za2 = kron(kron(eye(16),z),eye(2)); za3 = kron(eye(32),z);

        alpha = -(1/8)*(Delta);
        alpha_ss = -(1/6)*(Delta)^(1/3);
        alpha_sx = (1/6)*(Delta)^(2/3);
        alpha_zz = (1/24)*(Delta);
 %      have not add coefficient
        LHS = S(:,:,1)*S(:,:,2)*S(:,:,3);
        RHS = alpha*eye(2^(n+3)) + alpha_ss*(S(:,:,1)^2 + S(:,:,2)^2 + S(:,:,3)^2) + alpha_sx*(S(:,:,1)*xa1 + S(:,:,2)*xa2 + S(:,:,3)*xa3) + alpha_zz*(za1*za2 + za1*za3 + za2*za3);

    elseif strcmp(name_of_quadratization, 'P(3->2)KKR-A') % no coefficient needed
        assert(n == 3, 'P(3->2)KKR-A requires a 3-local term, please only give 3 operators.');
        assert(isequal(coefficient,1), 'Cannot change the coefficient of P(3->2)KKR-A');

        xa1 = kron(kron(eye(8),x),eye(4)); xa2 = kron(kron(eye(16),x),eye(2)); xa3 = kron(eye(32),x);
        za1 = kron(kron(eye(8),z),eye(4)); za2 = kron(kron(eye(16),z),eye(2)); za3 = kron(eye(32),z);

        alpha = (3/4)*(Delta);
        alpha_ss = (Delta)^(1/3);
        alpha_sx = -(Delta)^(2/3);
        alpha_zz = -(1/4)*(Delta);

        LHS = -6*S(:,:,1)*S(:,:,2)*S(:,:,3);
        RHS = alpha*eye(64) + 3*alpha_ss*eye(64) + alpha_sx*(S(:,:,1)*xa1 + S(:,:,2)*xa2 + S(:,:,3)*xa3) + alpha_zz*(za1*za2 + za1*za3 + za2*za3);

    elseif strcmp(name_of_quadratization, 'P(3->2)-DC1') || strcmp(name_of_quadratization, 'P(3->2)DC1')
        assert(n == 3, 'P(3->2)-DC1 requires a 3-local term, please only give 3 operators.');

        xa1 = kron(kron(eye(8),x),eye(4)); xa2 = kron(kron(eye(16),x),eye(2)); xa3 = kron(eye(32),x);
        za1 = kron(kron(eye(8),z),eye(4)); za2 = kron(kron(eye(16),z),eye(2)); za3 = kron(eye(32),z);

        alpha = (1/8)*Delta;
        alpha_ss = (1/6)*(Delta)^(1/3);
        alpha_sx = (-1/6)*(Delta)^(2/3);
        alpha_zz = (-1/24)*Delta;

        LHS = coefficient*S(:,:,1)*S(:,:,2)*S(:,:,3);
        RHS = alpha*eye(2^(n+3)) + alpha_ss*(S(:,:,1)^2 + S(:,:,2)^2 + S(:,:,3)^2) + alpha_sx*(S(:,:,1)*xa1 + S(:,:,2)*xa2 + S(:,:,3)*xa3) + alpha_zz*(za1*za2 + za1*za3 + za2*za3);

   elseif strcmp(name_of_quadratization, 'ZZZ-TI-CBBK')
        assert(n == 3, 'ZZZ-TI-CBBK requires a 3-local term, please only give 3 operators.');

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

        LHS = S(:,:,1)*S(:,:,2)*S(:,:,3);
        RHS = alpha_I*eye(16) + alpha_zi*S(:,:,1) + alpha_zj*S(:,:,2) + alpha_zk*S(:,:,3) + alpha_za*za + alpha_xa*xa + alpha_zzia*S(:,:,1)*za + alpha_zzja*S(:,:,2)*za + alpha_zzka*S(:,:,3)*za + alpha_zzij*S(:,:,1)*S(:,:,2) + alpha_zzik*S(:,:,1)*S(:,:,3) + alpha_zzjk*S(:,:,2)*S(:,:,3);

    elseif strcmp(name_of_quadratization, 'PSD-CBBK')
        assert(n >= 5, 'PSD-CBBK requires at least a 5-local term, please give at least 5 operators.');

        n_a = ceil(n/2);

        A = eye(2^(n+1)); B = eye(2^(n+1));
        for ind = 1:n_a
            A = A*S(:,:,ind);
        end

        for ind = n_a + 1:n
            B = B*S(:,:,ind);
        end
        za = kron(eye(2^n),z);
        xa = kron(eye(2^n),x);

        LHS = coefficient*A*B;
        RHS = (Delta)*((1*eye(2^(n+1)) - za)/2) + abs(coefficient)*((1*eye(2^(n+1)) + za)/2) + sqrt( abs(coefficient)*Delta/2 )*(sign(coefficient)*A - B)*xa;

    elseif strcmp(name_of_quadratization, 'PSD-OT')
        assert(n >= 4, 'PSD-OT requires at least a 4-local term, please give at least 4 operators.');

        A = eye(2^(n+1)); B = eye(2^(n+1));
        n_a = ceil(n/2);

        for ind = 1:n_a
            A = A*S(:,:,ind);
        end

        for ind = n_a + 1:n
            B = B*S(:,:,ind);
        end
        za = kron(eye(2^n),z);
        xa = kron(eye(2^n),x);

        LHS = coefficient*A*B;
        RHS = Delta*((1*eye(2^(n+1)) - za)/2) + (coefficient/2)*(A^2 + B^2) + sqrt( coefficient*Delta/2 )*(-A + B)*xa;

    elseif strcmp(name_of_quadratization, 'P(3->2)CBBK') || strcmp(name_of_quadratization, 'P(3->2)-CBBK')
      assert(n == 3, 'P(3->2)-CBBK requires a 3-local term, please only give 3 operators.');

      za = kron(eye(8),z);
      xa = kron(eye(8),x);

      alpha = Delta/2 + (1/2)*(coefficient/2)^(2/3)*Delta^(1/2)*( (sign(coefficient)^2) + 1 ) - (sign(coefficient)^2)*((coefficient/2)^(4/3))* ((sign(coefficient)^2) + 1);
      alpha_s3 = (1/2)*(coefficient/2)^(1/3)*(Delta^(1/2)) - (coefficient/4)*( (sign(coefficient)^2) + 1 );
      alpha_za = (-Delta/2) + (1/2)*(coefficient/2)^(2/3)*Delta^(1/2)*( (sign(coefficient)^2) + 1 ) - (sign(coefficient)^2)*((coefficient/2)^(4/3))* ((sign(coefficient)^2) + 1);
      alpha_s1_s2 = 2*sign(coefficient)*((coefficient/2)^(2/3))*(Delta^(1/2)) - 4*sign(coefficient)*((coefficient/2)^(4/3));
      alpha_s3_za = (-1/2)*(coefficient/2)^(1/3)*(Delta^(1/2)) - (coefficient/4)*( (sign(coefficient)^2) + 1 );
      alpha_s1_xa = sign(coefficient)*(coefficient/2)^(1/3)*(Delta^(3/4));
      alpha_s2_xa = (coefficient/2)^(1/3)*(Delta^(3/4));

      LHS = coefficient*S(:,:,1)*S(:,:,2)*S(:,:,3);
      RHS = alpha*eye(16) + alpha_s3*S(:,:,3) + alpha_za*za + alpha_s3_za*S(:,:,3)*za ...
          + alpha_s1_xa*S(:,:,1)*xa + alpha_s2_xa*S(:,:,2)*xa + alpha_s1_s2*S(:,:,1)*S(:,:,2);

    elseif strcmp(name_of_quadratization, 'P(3->2)-OT') || strcmp(name_of_quadratization, 'P(3->2)OT')
      assert(n == 3, 'P(3->2)-OT requires a 3-local term, please only give 3 operators.');

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

      LHS = coefficient*S(:,:,1)*S(:,:,2)*S(:,:,3);
      RHS = alpha*eye(16) + alpha_s1*(S(:,:,1))^2 + alpha_s2*(S(:,:,2))^2 + alpha_s3*S(:,:,3) ...
      + alpha_za*za + alpha_s1_s2*S(:,:,1)*S(:,:,2) + alpha_s1_s3*(S(:,:,1)^2)*S(:,:,3) + alpha_s2_s3*(S(:,:,2)^2)*S(:,:,3) + alpha_s3_za*S(:,:,3)*za ...
      + alpha_s1_xa*S(:,:,1)*xa + alpha_s2_xa*S(:,:,2)*xa;

    elseif strcmp(name_of_quadratization, 'P1B1-CBBK')
        assert(n >= 3, 'P1B1-CBBK requires at least a 3-local term, please give at least 3 terms.');

        za = kron(eye(2^n),z);
        xa = kron(eye(2^n),x);
        I_size = 2^(n+1);

        prod_LHS = eye(2^(n+1)); prod_A = eye(2^(n+1)); prod_B = eye(2^(n+1));
        for k = 1:n
            prod_LHS = prod_LHS*S(:,:,k);
        end

        for k = 1:(n-2)
            prod_A = prod_A*S(:,:,k);
        end

        for k = 1:(n-1)
            prod_B = prod_B*S(:,:,k);
        end

        LHS = coefficient*prod_LHS;
        RHS = (Delta*eye(I_size) + ((coefficient/2)^(1/3))*(Delta^(1/2))*S(:,:,n))*((1*eye(I_size) - za)/2) ...
            + ((coefficient/2)^(1/3))*(Delta^(3/4))*(sign(coefficient)*prod_A + S(:,:,n-1))*xa ...
            + ((coefficient^(2/3))/2)*( (sign(coefficient)^2) + 1 )*((2^(1/3))*(Delta^(1/2))*eye(I_size) - (coefficient^(1/3))*S(:,:,n) - (sign(coefficient)^2)*((2*coefficient)^(2/3))*eye(I_size))*((1*eye(I_size) + za)/2) ...
            + sign(coefficient)*((coefficient^(2/3))*(2^(1/3))*(Delta^(1/2)) - 4*((coefficient/2)^(4/3)))*prod_B;

    elseif strcmp(name_of_quadratization, 'P1B1-OT')
        assert(n >= 3, 'P1B1-CBBK requires at least a 3-local term, please give at least 3 terms.');

        za = kron(eye(2^n),z);
        xa = kron(eye(2^n),x);
        I_size = 2^(n+1);

        prod_LHS = eye(I_size); prod_A = eye(I_size);
        for k = 1:n
            prod_LHS = prod_LHS*S(:,:,k);
        end

        for k = 1:(n-2)
            prod_A = prod_A*S(:,:,k);
        end

        LHS = coefficient*prod_LHS;
        RHS = (Delta*eye(I_size) - (Delta^(2/3))*(coefficient^(1/3))*S(:,:,n))*((1*eye(I_size) - za)/2) ...
        + ((Delta^(2/3))*(coefficient^(1/3))/sqrt(2))*(-prod_A + S(:,:,n-1))*xa ...
        + ((Delta^(1/3))*(coefficient^(2/3))/2)*(-prod_A + S(:,:,n-1))^2 + (coefficient/2)*((prod_A)^2 + (S(:,:,n-1))^2)*S(:,:,n);

    elseif strcmp(name_of_quadratization, 'PSD-CN')
        assert(n >= 3, 'PSD-CN requires at least a 3-local term, please give at least 3 terms.')

        za_11 = kron(kron(eye(2^(n+0)),z),eye(2));
        xa_11 = kron(kron(eye(2^(n+0)),x),eye(2));

        za_1 = kron(kron(eye(2^(n+1)),z),eye(1));

        I_size = 2^(n+2);
        H_1j = eye(I_size); H_2j = eye(I_size);

        for k = 1:ceil(n/2)
           H_1j = H_1j*S(:,:,k);
        end

        for k = ceil(n/2)+1:n
            H_2j = H_2j*S(:,:,k);
        end

        R = 1; C = 1;
        beta = sqrt((coefficient*Delta)/(2*R)); alpha = Delta/(2*C);

        LHS = coefficient*H_1j*H_2j;
        RHS = alpha*( (eye(I_size) - za_11*za_1) ) ...
        + alpha*( (eye(I_size) - za_1) ) + alpha*( (eye(I_size) - za_1*za_1) ) ...
        + beta*( (H_1j - H_2j)*xa_11 ) + coefficient*eye(I_size);

    else
        disp('cannot find this method');
        LHS = []; RHS = [];
    end
end
