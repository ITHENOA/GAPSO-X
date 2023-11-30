clc;clear;close all;tic
global itmax1 itmax2 itmaxpso

% add to path
addpath('psoX\','./psoX/Neighborhood/',"psoX\optional\",...
    "psoX\Other_Functions\","psoX\Pertublation\","psoX\Swarm_Weight\");
addpath('Bench_Func\','first floor\','RS_bitBlock_method\','second floor\');

% floor 1
itmax1 = 1;

% floor 2
itmax2 = 1;

% PSOX
itmaxpso = 50;

% run code
run("Top_Floor.m")

toc