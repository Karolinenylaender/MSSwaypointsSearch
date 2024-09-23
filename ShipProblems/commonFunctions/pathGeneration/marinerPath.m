function [simdata, state] = marinerPath(wpt, Delta_h, R_switch)
        clear LOSchi EKF_5states
        if nargin ==1, R_switch = 400; end
        wayPoints = [wpt.pos.x wpt.pos.y];
        
    
        % LOS parameters
        %Delta_h = 500;                   % Look-ahead distance
        %R_switch = 400;                  % Radius of switching circle
        K_f = 0.2;                       % LOS observer gain
    
        % PID pole placement algorithm (Fossen 2021, Section 15.3.4)
        wn = 0.05;                       % Closed-loop natural frequency
        T = 107.3;                       % Nomoto time constant
        K = 0.185;                       % Nomoto gain constant
        Kp = (T/K) * wn^2;               % Proportional gain
        Td = T/(K*Kp) * (2*1*wn - 1/T);  % Derivative time constant
        Ti = 10 / wn;                    % Integral time constant
            
        % Reference model specifying the heading autopilot closed-loop dynamics
        wn_d = 0.1;                      % Natural frequency (rad/s)
        zeta_d = 1.0;                    % Relative damping factor (-)
        r_max = deg2rad(1.0);            % Maximum turning rate (rad/s)
        
        % Initial states
        x_hat = zeros(5,1);              % xhat = [ x, y, U, chi, oemga_chi ]'
        x = zeros(7,1);                  % x = [ u v r x y psi delta ]'
        U0 = 7.7175;                     % Nominal speed
        e_int = 0;                       % Autopilot integral state 
        delta_c = 0;                     % Initial rudder angle command
        psi_d = 0;                       % Initial desired heading angle
        chi_d = 0;                       % Initial desired course angle
        omega_chi_d = 0;                 % Initial desired course rate
        r_d = 0;                         % Initial desired rate of turn
        a_d = 0;                         % Initial desired acceleration
        
        % maximum limits
        delta_c_max = deg2rad(40);
        omega_chi_d_max = deg2rad(1);
    
        last_waypoint = wayPoints(end,:);
        reached_every_waypoint = false;
    
        t_f = 3000;              % Final simulation time (sec)
        h  = 0.05;                % Sampling time [s]
        Z = 2;                    % GNSS measurement frequency (2 times slower)
        
        t = 0;
        N = round(t_f/h)*2;                    % Number of samples %KAROLINE
        simdata = zeros(N+1,17);             % Memory allocation
        state = zeros(N+1,14); % % x x_dot x_dot_dot angle angle_dot angle_dotdot
     
        for i=1:N+1
        
            t = (i-1) * h;                   % Simulation time in seconds
        
            % Measurements with measurement noise    
            r    = x(3) + 0.0001 * randn; % denne randomnessen burde påvirke begge målingene likt
            xpos = x(4) + 0.01 * randn;
            ypos = x(5) + 0.01 * randn;
            psi  = x(6) + 0.0001 * randn;
        
            % EKF estimates used for path-following control
            U_hat = x_hat(3);
            chi_hat = x_hat(4);
            omega_chi_hat = x_hat(5);
        
            % Guidance and control system 
            % LOS course autopilot for straight-line path following
            chi_ref = LOSchi(xpos, ypos, Delta_h, R_switch, wpt);
        
            % LOS observer for estimation of chi_d and omega_chi_d
            [chi_d, omega_chi_d] = LOSobserver(...
                chi_d, omega_chi_d, chi_ref, h, K_f);
        
            omega_chi_d = sat(omega_chi_d, omega_chi_d_max); % Max value
        
            % PID course autopilot
            e = ssa(chi_hat - chi_d);
            delta_PID = (1/K) * omega_chi_d ...               % Feedforward
               -Kp * ( e + Td * (omega_chi_hat - omega_chi_d) ... % PID
               + (1/Ti) * e_int );                 
    
            delta_c = sat(delta_c, delta_c_max);             % Maximum rudder angle
        
            % Ship dynamics
            [xdot,U] = mariner(x,delta_c, U0);     
            
            % Store data for presentation
            simdata(i,:) = [t, x', U, psi_d, r_d, chi_d, omega_chi_d, delta_c, ...
                U_hat, chi_hat, omega_chi_hat]; 
            
            
            state(i,:) = [x' xdot'];
            % Numerical integration
            x = x + h * xdot;                             % Euler's method
            e_int = e_int + h * e;
            delta_c = delta_c + h * (delta_PID - delta_c) / 1.0;
        
            % Propagation of the EKF states
            x_hat = EKF_5states(xpos, ypos, h, Z, 'NED', ...
                100*diag([0.1,0.1]), 1000*diag([1 1]), 0.00001, 0.00001);
    
            %if ((last_waypoint(1) - R_switch <= xpos) && (xpos <= last_waypoint(1) + R_switch)) && ((last_waypoint(2) - R_switch <= ypos) && (ypos <= last_waypoint(2) + R_switch))
            if (abs(last_waypoint(1) -xpos) <= round(R_switch/2)) && (abs(last_waypoint(2)-ypos) <= round(R_switch/2))
                reached_every_waypoint = true;
                
            end
            %if i>= round(N/2) || reached_every_waypoint == true 
            if reached_every_waypoint == true && i>= round(N/3)
                simdata(i:end,:) = [];
                state(i:end,:) = [];
                return
            end 
        end
     end

