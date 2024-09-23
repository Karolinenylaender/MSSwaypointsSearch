function [simdata, state] = otterPathILOS(wpt, R_switch)
    [simdata] = otterPathControlflag(wpt, R_switch, "ILOS")
    state = 0
end