function [simdata] = otterPathControlflag(wpt, R_switch, controlMethod)
    %clearvars;                                  % Clear variables from memory
    close all;                                  % Close all figure windows
    clear ALOSpsi ILOSpsi crosstrackHermiteLOS  % Clear persistent variable

    if controlMethod == "ALOS"
        ControlFlag = 2
    elseif controlMethod == "ILOS"
        ControlFlag = 3
    end

    %% USER INPUTS
    h  = 0.05;                       % Sampling time [s]
    N  = 20000*2;                      % Number of samples


    % Load condition
    mp = 25;                         % Payload mass (kg), maximum value 45 kg
    rp = [0.05 0 -0.35]';            % Location of payload (m)
    
    % Ocean current
    V_c = 0.3;                       % Ocean current speed (m/s)
    beta_c = deg2rad(30);            % Ocean current direction (rad)
    
    % Waypoints
    wpt.pos.x = [0 0   150 150 -100 -100 200]';
    wpt.pos.y = [0 200 200 -50  -50  250 250]';
    wayPoints = [wpt.pos.x wpt.pos.y];
    
    % ALOS and ILOS parameters
    Delta_h = 10;                    % Look-ahead distance
    gamma_h = 0.001;                 % ALOS adaptive gain
    kappa = 0.001;                   % ILOS integral gain
    
    % Additional parameter for straight-line path following
    %R_switch = 5;                    % Radius of switching circle
    K_f = 0.3;                       % LOS observer gain
    
    % Initial heading, vehicle points towards next waypoint
    psi0 = atan2(wpt.pos.y(2) - wpt.pos.y(1), wpt.pos.x(2) - wpt.pos.x(1));
    
    % Additional parameters for Hermite spline path following
    Umax = 2;                        % Maximum speed for Hermite spline LOS
    idx_start = 1;                   % Initial index for Hermite spline
    [w_path, x_path, y_path, dx, dy, pi_h, pp_x, pp_y, N_horizon] = ...
        hermiteSpline(wpt, Umax, h); % Compute Hermite spline for path following
    
    % Otter USV input matrix
    [~,~,M, B_prop] = otter();
    Binv = inv(B_prop);              % Invert input matrix for control allocation
    
    % PID heading autopilot parameters (Nomoto model: M(6,6) = T/K)
    T = 1;                           % Nomoto time constant
    K = T / M(6,6);                  % Nomoto gain constant
    
    wn = 1.5;                        % Closed-loop natural frequency (rad/s)
    zeta = 1.0;                      % Closed-loop relative damping factor (-)
    
    Kp = M(6,6) * wn^2;                     % Proportional gain
    Kd = M(6,6) * (2 * zeta * wn - 1/T);    % Derivative gain
    Td = Kd / Kp;                           % Derivative time constant
    Ti = 10 / wn;                           % Integral time constant
    
    % Reference model parameters
    wn_d = 1.0;                      % Natural frequency (rad/s)
    zeta_d = 1.0;                    % Relative damping factor (-)
    r_max = deg2rad(10.0);           % Maximum turning rate (rad/s)
    
    % Propeller dynamics
    T_n = 0.1;                       % Propeller time constant (s)
    n = [0 0]';                      % Initial propeller speed, [n_left n_right]'
    
    % Initial states
    eta = [0 0 0 0 0 psi0]';         % State vector, eta = [x y z phi theta psi]'
    nu  = [0 0 0 0 0 0]';            % Velocity vector, nu  = [u v w p q r]'
    z_psi = 0;                       % Integral state for heading control
    psi_d = eta(6);                  % Initial desired heading
    r_d = 0;                         % Initial desired rate of turn
    a_d = 0;                         % Initial desired acceleration

    %% MAIN LOOP
    simdata = zeros(N+1, 15);        % Preallocate table for simulation data

    last_waypoint = wayPoints(end,:);
        reached_every_waypoint = false;

    for i = 1:N+1
        t = (i-1) * h;                  % Time (s)
        % Measurements with noise
        x = eta(1) + 0.01 * randn;      % Noisy x measurement
        y = eta(2) + 0.01 * randn;      % Noisy y measurement
        r = nu(6) + 0.001 * randn;      % Noisy rate of turn
        psi = eta(6) + 0.001 * randn;   % Noisy heading
    
        % Guidance and control system
        switch ControlFlag
            % case 1  % PID heading autopilot with reference model
            %     % Reference model, step input adjustments
            %     psi_ref = psi0;
            %     if t > 100; psi_ref = deg2rad(0); end
            %     if t > 500; psi_ref = deg2rad(-90); end
            % 
            %     % Reference model propagation
            %     [psi_d, r_d, a_d] = refModel(psi_d, r_d, a_d, psi_ref, r_max, ...
            %                                  zeta_d, wn_d, h, 1);
            % 
            case 2  % ALOS heading autopilot straight-line path following
                psi_ref = ALOSpsi(x, y, Delta_h, gamma_h, h, R_switch, wpt);
                [psi_d, r_d] = LOSobserver(psi_d, r_d, psi_ref, h, K_f);
    
            case 3  % ILOS heading autopilot straight-line path following
                psi_ref = ILOSpsi(x, y, Delta_h, kappa, h, R_switch, wpt);
                [psi_d, r_d] = LOSobserver(psi_d, r_d, psi_ref, h, K_f);
    
            % case 4  % ALOS heading autopilot, cubic Hermite spline interpolation
            %     [psi_ref, idx_start] = crosstrackHermiteLOS(w_path, x_path, ...
            %         y_path, dx, dy, pi_h, x, y, h, Delta_h, pp_x, pp_y, ...
            %         idx_start, N_horizon, gamma_h);
            %     [psi_d, r_d] = LOSobserver(psi_d, r_d, psi_ref, h, K_f);
        end
    
        % PID heading (yaw moment) autopilot and forward thrust
        tau_X = 100;                              % Constant forward thrust
        tau_N = (T/K) * a_d + (1/K) * r_d - ...   % Yaw moment control
                Kp * (ssa(psi - psi_d) + ...      % Proportional term
                Td * (r - r_d) + (1/Ti) * z_psi); % Derivative and integral terms
    
        % Control allocation
        u = Binv * [tau_X; tau_N];      % Compute control inputs for propellers
        n_c = sign(u) .* sqrt(abs(u));  % Convert to required propeller speeds
    
        % Store simulation data
        simdata(i, :) = [t, eta', nu', r_d, psi_d];
    
        % USV dynamics
        xdot = otter([nu; eta], n, mp, rp, V_c, beta_c);  % State derivatives
    
        % Euler's integration method (k+1)
        nu = nu + h * xdot(1:6);                % Update velocity states
        eta = eta + h * xdot(7:12);             % Update position states
        n = n + h/T_n * (n_c - n);              % Update propeller speeds
        z_psi = z_psi + h * ssa(psi - psi_d);   % Update integral state

        if (abs(last_waypoint(1) -x) <= round(R_switch/2)) && (abs(last_waypoint(2)-y) <= round(R_switch/2))
                reached_every_waypoint = true;  
        end
        
        if reached_every_waypoint == true && i>= round(N/3)
            simdata(i:end,:) = [];
            %state(i:end,:) = [];
            return
        end 
    end
end
