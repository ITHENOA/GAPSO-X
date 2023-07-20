clc;clear;close all;tic
global itMax_floor1 itMax_floor2 itMax_psox

% floor 1
itMax_floor1 = 1;

% floor 2
itMax_floor2 = 1;

% PSOX
itMax_psox = 50;

% run code
run("Top_Floor.m")

toc