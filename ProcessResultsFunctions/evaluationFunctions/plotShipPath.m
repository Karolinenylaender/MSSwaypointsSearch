function plotShipPath(fullPath, pointsMatrix)
    close all;
    if size(fullPath,2) == 2
        xpath = fullPath(:,1);
        ypath = fullPath(:,2);

        xpoints = pointsMatrix(:,1);
        ypoints = pointsMatrix(:,2);

        figure
        plot(ypath,xpath)
        hold on;
        plot(ypoints, xpoints, 'rx', 'MarkerSize', 15);
        hold off;
        grid on;
        xlabel("y axis")
        ylabel("x axis")
    else
        xpath = fullPath(:,1);
        ypath = fullPath(:,2);
        zpath = fullPath(:,3);
        xpoints = pointsMatrix(:,1);
        ypoints = pointsMatrix(:,2);
        zpoints = pointsMatrix(:,3);

        subplot(3,1,1)
        plot(ypath,xpath)
        hold on
         plot(ypoints, xpoints, 'rx', 'MarkerSize', 15);
         hold off
        xlabel("y axis")
        ylabel("x axis")
        grid on

        subplot(3,1,2)
        plot(ypath,zpath)
        hold on;
        plot(ypoints, zpoints, 'rx', 'MarkerSize', 15);
        hold off;
        xlabel("y axis")
        ylabel("z axis")
        grid on

        subplot(3,1,3)
        plot3(ypath, xpath, zpath)
        hold on
        plot3(ypoints, xpoints, zpoints, 'ro', 'MarkerSize', 15);
        hold off;
        grid on;
        set(gca, 'ZDir', 'reverse');
        xlabel("y axis")
        ylabel("x axis")
        zlabel("z axis")
        view(-25, 30)
    end
end
