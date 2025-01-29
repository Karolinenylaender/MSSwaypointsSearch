function plotAngles(path, angles, figureNumber, titleText)
    if nargin <3 
        figureNumber = 1;
        titleText = ""
    elseif nargin <4
        titleText = ""

    end
    x = path(:,1);
    y = path(:,2);
    z = path(:,3);
    phi = angles(:,1);
    theta = angles(:,2);
    psi = angles(:,3);
    u = angles(:,4);
    v = angles(:,5);
    w = angles(:,6);
    p = angles(:,7);
    q = angles(:,8);
    r = angles(:,9);
    Vc = angles(:,10);
    betaVc = angles(:,11);
    wc = angles(:,12);

    t = 1:length(phi);

    % figure(figureNumber+2)
    % subplot(311),plot(t,sqrt(u.^2+v.^2),t,Vc)
    % xlabel('Time (s)'),grid
    % legend('Vehicle horizontal speed (m/s)','Ocean current horizontal speed (m/s)') %   'Location',legendLocation)
    % subplot(312),plot(t,w,t,wc)
    % xlabel('Time (s)'),grid
    % legend('Vehicle heave velocity (m/s)','Ocean current heave velcoity (m/s)')
    % subplot(313),plot(t,rad2deg(betaVc),'r')
    % xlabel('Time (s)'),grid
    % legend('Ocean current direction (deg)') %,'Location'),legendLocation)
    % set(findall(gcf,'type','line'),'linewidth',2)
    % set(findall(gcf,'type','text'),'FontSize',14)
    % %set(findall(gcf,'type','legend'),'FontSize',legendSize)

    figure(figureNumber)
    subplot(611),plot(t,rad2deg(phi))
    xlabel('Time (s)'),title('Roll angle (deg)'),grid
    subplot(612),plot(t,rad2deg(theta))
    xlabel('Time (s)'),title('Pitch angle (deg)'),grid
    %legend('True','Desired')
    subplot(613),plot(t,rad2deg(psi))
    xlabel('Time (s)'),title('Yaw angle (deg)'),grid
    subplot(614),plot(t,(180/pi)*p)
    xlabel('Time (s)'),title('Roll rate (deg/s)'),grid
    subplot(615),plot(t,(180/pi)*q)
    xlabel('Time (s)'),title('Pitch rate (deg/s)'),grid
    subplot(616),plot(t,(180/pi)*r)
    xlabel('Time (s)'),title('Yaw rate (deg/s)'),grid
    set(findall(gcf,'type','line'),'linewidth',2)
    set(findall(gcf,'type','text'),'FontSize',14)
    set(gcf,'position',[2200 200 1200 1400])
    sgtitle(titleText)
    
    %set(findall(gcf,'type','legend'),'FontSize',legendSize)

    figure(figureNumber+1)
    %if ~isoctave; set(gcf,'Position',[scrSz(3)/3, 1, scrSz(3)/3, scrSz(4)]); end
    %if ControlFlag == 3; z_d = eta(:,3); end
    %subplot(411),plot(t,phi)
    %xlabel('Time (s)'),title('Heave position (m)'),grid
    %legend('True','Desired')
    subplot(611),plot(t,x)
    xlabel('Time (s)'),title('North position (m)'),grid
    subplot(612),plot(t,y)
    xlabel('Time (s)'),title('East position (m) '),grid
    subplot(613),plot(t,z)
    xlabel('Time (s)'),title(' Downwards position (m)'),grid
    subplot(614),plot(t,u)
    xlabel('Time (s)'),title('Surge velocity (m/s)'),grid
    subplot(615),plot(t,v)
    xlabel('Time (s)'),title('Sway velocity (m/s)'),grid
    subplot(616),plot(t,w)
    xlabel('Time (s)'),title('Heave velocity (m/s)'),grid
    set(gcf,'position',[1000 200 1200 1400])
    sgtitle(titleText)
    
    %legend('True','Desired')
    set(findall(gcf,'type','line'),'linewidth',2)
    set(findall(gcf,'type','text'),'FontSize',14)
    %set(findall(gcf,'type','legend'),'FontSize',legendSize)

    



    %% Sideslip and angle of attack
    % alpha  = angles(:,1);
    % alpha_c = angles(:,2);
    % alpha_c_hat= angles(:,3);
    % beta = angles(:,4);
    % beta_c = angles(:,5);
    % beta_c_hat = angles(:,6);
    % t = 0:(length(alpha)-1);
    % 
    % %t = 0:h:T_final
    % 
    % figure(figureNumber)
    % %if ~isoctave; set(gcf,'Position',[100,scrSz(4)/2,scrSz(3)/3,scrSz(4)]); end
    % subplot(211)
    % plot(t,rad2deg(alpha),'g',t,rad2deg(alpha_c),'b',...
    %     t,rad2deg(alpha_c_hat),'r')
    % title('Angle of attack (deg)')
    % xlabel('Time (s)')
    % grid
    % legend('\alpha','\alpha_c','\alpha_c estimate')
    % subplot(212)
    % plot(t,rad2deg(beta),'g',t,rad2deg(beta_c),'b',...
    %     t,rad2deg(beta_c_hat),'r')
    % title('Sideslip angle (deg)')
    % xlabel('Time (s)')
    % grid
    % legend('\beta','\beta_c','\beta_c estimate')
    % 
    % set(findall(gcf,'type','line'),'linewidth',2)
    % set(findall(gcf,'type','text'),'FontSize',14)
    % %set(findall(gcf,'type','legend'),'FontSize',legendSize)

end