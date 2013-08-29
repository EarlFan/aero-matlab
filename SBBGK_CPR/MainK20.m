%% Run Cases for ploting Data
% Evaluate Matrix of Results
clc; clear all; close all; 

if matlabpool('size') == 0  % checking to see if my pool is already open.
    matlabpool open 12       % Simultaneous cases to evaluate in K20.
end

%% Number of cases
case_idx = 1:(12*4);                    

%% Simulation Parameters Matrix
% Simulation Name.
name        ='SBBGK1d'; 

% CFL condition.
CFL         = [0.15 0.15 0.15 0.15 0.15 0.15 0.15 0.15 0.15 0.15 0.15 0.15 ...
               0.15 0.15 0.15 0.15 0.15 0.15 0.15 0.15 0.15 0.15 0.15 0.15 ...
               0.15 0.15 0.15 0.15 0.15 0.15 0.15 0.15 0.15 0.15 0.15 0.15 ...
               0.15 0.15 0.15 0.15 0.15 0.15 0.15 0.15 0.15 0.15 0.15 0.15];
           
% {1} Relaxation Model, {2} Euler Limit.
f_case      = [1 1 1 1 1 1 1 1 1 1 1 1 ...
               1 1 1 1 1 1 1 1 1 1 1 1 ...
               1 1 1 1 1 1 1 1 1 1 1 1 ...
               1 1 1 1 1 1 1 1 1 1 1 1];

% Relaxation time.
tau         = [1e-1 1e-1 1e-1 1e-1 1e-1 1e-1 1e-1 1e-1 1e-1 1e-1 1e-1 1e-1 ...
               1e-2 1e-2 1e-2 1e-2 1e-2 1e-2 1e-2 1e-2 1e-2 1e-2 1e-2 1e-2 ...
               1e-3 1e-3 1e-3 1e-3 1e-3 1e-3 1e-3 1e-3 1e-3 1e-3 1e-3 1e-3 ...
               1e-4 1e-4 1e-4 1e-4 1e-4 1e-4 1e-4 1e-4 1e-4 1e-4 1e-4 1e-4];   

% Statistic: {-1} BE, {0} MB, {1} FD.
theta       = [-1 0 1 -1 0 1 -1 0 1 -1 0 1 ...
               -1 0 1 -1 0 1 -1 0 1 -1 0 1 ...
               -1 0 1 -1 0 1 -1 0 1 -1 0 1 ...
               -1 0 1 -1 0 1 -1 0 1 -1 0 1];        

% for {1} NC, {2} GH.
quad        = [2 2 2 2 2 2 1 1 1 1 1 1 ...
               2 2 2 2 2 2 1 1 1 1 1 1 ...
               2 2 2 2 2 2 1 1 1 1 1 1 ...
               2 2 2 2 2 2 1 1 1 1 1 1];        

% {1} UU. model, {2} ES model.
fmodel      = [1 1 1 1 1 1 1 1 1 1 1 1 ...
               1 1 1 1 1 1 1 1 1 1 1 1 ...
               1 1 1 1 1 1 1 1 1 1 1 1 ...
               1 1 1 1 1 1 1 1 1 1 1 1];        

% for {1} = Nodal DG.
method      = [1 1 1 1 1 1 1 1 1 1 1 1 ...
               1 1 1 1 1 1 1 1 1 1 1 1 ...
               1 1 1 1 1 1 1 1 1 1 1 1 ...
               1 1 1 1 1 1 1 1 1 1 1 1];        

% Reimann IC cases: 1~12 cases, see SSBGK_IC1d.m for more refs.
IC_case     = [7 7 7 7 7 7 8 8 8 8 8 8 ...
               7 7 7 7 7 7 8 8 8 8 8 8 ...
               7 7 7 7 7 7 8 8 8 8 8 8 ...
               7 7 7 7 7 7 8 8 8 8 8 8];        

% 0: no, 1: yes please! <- matlab plot requires GUI!
plot_figs   = [0 0 0 0 0 0 0 0 0 0 0 0 ...
               0 0 0 0 0 0 0 0 0 0 0 0 ...
               0 0 0 0 0 0 0 0 0 0 0 0 ...
               0 0 0 0 0 0 0 0 0 0 0 0];        

% 0: no, 1: yes please!
write_ans   = [1 1 1 1 1 1 1 1 1 1 1 1 ...
               1 1 1 1 1 1 1 1 1 1 1 1 ...
               1 1 1 1 1 1 1 1 1 1 1 1 ...
               1 1 1 1 1 1 1 1 1 1 1 1];       

%% Using DG
% Polinomial Degree.
P_deg       = [3 3 3 4 4 4 3 3 3 4 4 4 ...
               3 3 3 4 4 4 3 3 3 4 4 4 ...
               3 3 3 4 4 4 3 3 3 4 4 4 ...
               3 3 3 4 4 4 3 3 3 4 4 4];        

% Polinomials Points
Pp          = P_deg+1;  

%% Using RK integration time step
% Number of RK stages. (fixed for the moment!)
RK_stages   = [3 3 3 3 3 3 3 3 3 3 3 3 ...
               3 3 3 3 3 3 3 3 3 3 3 3 ...
               3 3 3 3 3 3 3 3 3 3 3 3 ...
               3 3 3 3 3 3 3 3 3 3 3 3];        

%% Grid size and Elements
% Desided number of points in our domain.
nx           = [100 100 100 100 100 100 100 100 100 100 100 100 ...
                100 100 100 100 100 100 100 100 100 100 100 100 ...
                100 100 100 100 100 100 100 100 100 100 100 100 ...
                100 100 100 100 100 100 100 100 100 100 100 100];              

%% Excecute SBBGK in Parallel using 4 processors
parfor i = case_idx
    SBBGK_1d_NDG_func(name,CFL(i),tau(i),theta(i),quad(i),method(i),IC_case(i), ...
        plot_figs(i),write_ans(i),P_deg(i),Pp(i),fmodel(i),f_case(i),RK_stages(i),nx(i))
end
matlabpool close

%% if everything is ok then, tell me:
fprintf('All Results have been succesfully saved!\n')
