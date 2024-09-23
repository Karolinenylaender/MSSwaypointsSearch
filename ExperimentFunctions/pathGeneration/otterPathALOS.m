function [simdata, state] = otterPathALOS(wpt, R_switch)
    [simdata] = otterPathControlflag(wpt, R_switch, "ALOS")
    state = 0
end