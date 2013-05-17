clear all
close all
clc

n = 10;
[X, Y] = meshgrid(1:n, 1:n);
Z = ones(n, n);

mesh(X, Y, Z);