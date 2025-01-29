function plotSideslipAndAngleofAttack(angles, figureNumber)
    if nargin <2
        figureNumber = 1;
    end
    %% Sideslip and angle of attack
    alpha  = angles(:,1);
    alpha_c = angles(:,2);
    alpha_c_hat= angles(:,3);
    beta = angles(:,4);
    beta_c = angles(:,5);
    beta_c_hat = angles(:,6);
    t = 0:(length(alpha)-1);

    %t = 0:h:T_final
    
    figure(figureNumber)
    %if ~isoctave; set(gcf,'Position',[100,scrSz(4)/2,scrSz(3)/3,scrSz(4)]); end
    subplot(211)
    plot(t,rad2deg(alpha),'g',t,rad2deg(alpha_c),'b',...
        t,rad2deg(alpha_c_hat),'r')
    title('Angle of attack (deg)')
    xlabel('Time (s)')
    grid
    legend('\alpha','\alpha_c','\alpha_c estimate')
    subplot(212)
    plot(t,rad2deg(beta),'g',t,rad2deg(beta_c),'b',...
        t,rad2deg(beta_c_hat),'r')
    title('Sideslip angle (deg)')
    xlabel('Time (s)')
    grid
    legend('\beta','\beta_c','\beta_c estimate')
    
    set(findall(gcf,'type','line'),'linewidth',2)
    set(findall(gcf,'type','text'),'FontSize',14)
    %set(findall(gcf,'type','legend'),'FontSize',legendSize)

end