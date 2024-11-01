function [angles, fullpath] = extractAnglesAndPath(simdata,ALOSdata, ship)
    if ship == "mariner"
        x = simdata(:,4);
        y = simdata(:,5);
        fullpath = [x y];

        u     = simdata(:,1); 
        v     = simdata(:,2);          
        % r     = rad2deg(simdata(:,3));  
        % psi   = rad2deg(simdata(:,6));
        % delta = -rad2deg(simdata(:,7));     % delta = -delta_r (physical angle)
        r     = simdata(:,3);  
        psi   = simdata(:,6);
        delta = simdata(:,7);     
        
        %delta_c = rad2deg(simdata(:,12));
        %U_hat = simdata(:,13);
        %chi_hat = rad2deg(simdata(:,14));
        %omega_chi_hat = rad2deg(simdata(:,15));

        angles = [u v r psi delta];
        


        % 
        % U0 = 7.7175; 
        % 
        % psi   = rad2deg(simdata(:,6));
        % delta = -rad2deg(simdata(:,7));     % delta = -delta_r (physical angle)
        % psi_d = rad2deg(simdata(:,8));
        % r_d   = rad2deg(simdata(:,9));
        % chi_d = rad2deg(simdata(:,10));
        % omega_chi_d = rad2deg(simdata(:,11));
        % delta_c = rad2deg(simdata(:,12));
        % U_hat = simdata(:,13);
        % chi_hat = rad2deg(simdata(:,14));
        % omega_chi_hat = rad2deg(simdata(:,15));
        % 
        % %U     = sqrt( (U0 + u).^2 + v.^2);          % SOG
        % beta_c = rad2deg(atan2(v, U0 + u));         % Crab angle
        % chi = ssa(psi + beta_c, 'deg');             % COG

        %angles = [beta_c chi psi delta psi_d r_d chi_d omega_chi_d delta_c U_hat chi_hat omega_chi_hat];

        %angles = [eta(:,4) eta(:,5) eta(:,6)]
    elseif ship == "remus100"
        % alpha_c_hat = ALOSdata(:,3);
        % beta_c_hat = ALOSdata(:,4);
        % 
        % Vc      = simdata(:,6);
        % betaVc  = simdata(:,7);
        % wc      = simdata(:,8);
        % nu      = simdata(:,12:17);

        eta = simdata(:,18:23);
        x_mutated = eta(:,1);
        y_mutated = eta(:,2);
        z_mutated = eta(:,3);
        fullpath = [x_mutated y_mutated z_mutated];

        angles = [eta(:,4) eta(:,5) eta(:,6)]; % nu Vc betaVc wc];

        % uc = Vc .* cos(betaVc);
        % vc = Vc .* sin(betaVc);
        % alpha_c = atan( (nu(:,2).*sin(eta(:,4))+nu(:,3).*cos(eta(:,4))) ./ nu(:,1) );
        % Uv = nu(:,1) .* sqrt( 1 + tan(alpha_c).^2 );
        % beta_c = atan( ( nu(:,2).*cos(eta(:,4))-nu(:,3).*sin(eta(:,4)) ) ./ ...
        %     ( Uv .* cos(eta(:,5)-alpha_c) ) );
        % alpha = atan2( (nu(:,3)-wc), (nu(:,1)-uc) );
        % beta  = atan2( (nu(:,2)-vc), (nu(:,1)-uc) );

        % angles = [alpha, alpha_c, alpha_c_hat, beta, beta_c, beta_c_hat];
    elseif ship == "nspauv"
        % alpha_c_hat = ALOSdata(:,3);
        % beta_c_hat = ALOSdata(:,4);
        % 
        % Vc       = simdata(:,27);
        % betaVc   = simdata(:,28);
        % wc       = simdata(:,29);
        eta = simdata(:,17:22);
        x_mutated = eta(:,1);
        y_mutated = eta(:,2);
        z_mutated = eta(:,3);
        fullpath = [x_mutated y_mutated z_mutated];
        angles = [eta(:,4) eta(:,5) eta(:,6)];

        % uc = Vc .* cos(betaVc);
        % vc = Vc .* sin(betaVc);
        % alpha_c = atan( (nu(:,2).*sin(eta(:,4))+nu(:,3).*cos(eta(:,4))) ./ nu(:,1) );
        % Uv = nu(:,1) .* sqrt( 1 + tan(alpha_c).^2 );
        % beta_c = atan( ( nu(:,2).*cos(eta(:,4))-nu(:,3).*sin(eta(:,4)) ) ./ ...
        %     ( Uv .* cos(eta(:,5)-alpha_c) ) );
        % 
        % U_r = sqrt( (nu(:,1)-uc).^2 + (nu(:,2)-vc).^2 + (nu(:,3)-wc).^2) ;
        % alpha = atan2( (nu(:,3)-wc), (nu(:,1)-uc) );
        % beta  = asin( (nu(:,2)-vc) ./ U_r );
        % 
        % angles = [alpha, alpha_c, alpha_c_hat, beta, beta_c, beta_c_hat];
    end
end
