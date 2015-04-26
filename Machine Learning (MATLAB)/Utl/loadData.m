% FILE: loadData.m
% AUTHORS: Chris Hoder, Ben Southworth
% DATE: 3/5/2013
% COSC 74 Final Project
%
% This script will open up a file dialog for the user to select a matlab
% file they wish to load. This script will also clear the command window,
% close all figures and clear all variables.
clc;close all;clear all
[FileName,PathName,~] = uigetfile();
load([PathName,FileName]);


