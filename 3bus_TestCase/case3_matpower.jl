#case3_matpower.jl

#MATPOWER case writer for the 3-bus dq0EMTPSiD.jl study

const bus3_BRANCH_DATA = Tuple{Int,Int,Float64,Float64,Float64,Float64}[
    (1, 2, 0.006, 0.060, 0.100, 0.0),# here Line 1-2: from, to, r, x, b, tap
    (2, 3, 0.008, 0.080, 0.120, 0.0),        #Line 2-3: from, to, r, x, b, tap
    (1, 3, 0.010, 0.100, 0.150, 0.0),       #Line 1-3: from, to, r, x, b, tap
]

function write_modified_3bus_case(path::String)
    case_txt = """
function mpc = modified_3bus_configurable
mpc.version = '2';
mpc.baseMVA = 100;

%%Note on d bus data




% bus_i type Pd     Qd    Gs  Bs   area Vm    Va   baseKV zone Vmax Vmin
mpc.bus = [
    1  2   100.0  30.0  0   0    1  0.96  0.0  230.0  1  1.06  0.94;
    2  2   120.0  40.0  0   30   1  1.03  0.0  230.0  1  1.06  0.94;
    3  3   100.0  30.0  0   0    1  1.00  0.0  230.0  1  1.06  0.94;
];

%% here generator data



% bus  Pg     Qg   Qmax    Qmin   Vg    mBase  status Pmax   Pmin
mpc.gen = [
    1  110.0  0.0  200.0  -200.0  0.96  300.0  1  270.0  0.0;
    2  100.0  0.0  170.0  -170.0  1.03  250.0  1  225.0  0.0;
    3  120.0  0.0  260.0  -260.0  1.00  400.0  1  360.0  0.0;
];

%%here branch data

%
% fbus tbus r      x      b      rateA rateB rateC tap angle status angmin angmax
mpc.branch = [
    1  2  0.006  0.060  0.100  800   800   800   0   0     1      -360   360;
    2  3  0.008  0.080  0.120  800   800   800   0   0     1      -360   360;
    1  3  0.010  0.100  0.150  800   800   800   0   0     1      -360   360;
];

%%here generator cost data

% model startup shutdown n c2   c1 c0
mpc.gencost = [
    2     0       0      3 0.01 20 0;
    2     0       0      3 0.01 20 0;
    2     0       0      3 0.01 20 0;
];
"""
    open(path, "w") do io
        write(io, case_txt)
    end
end