function [ backgroundLevel ] = findBackgroundLevel( g2single, g2classical, taulist, targetValue )
%FINDBACKGROUNDLEVEL Summary of this function goes here
%   Detailed explanation goes here
	tauIsZero = taulist == 0;
	backgroundLevel = (targetValue - g2single(tauIsZero))/(g2classical(tauIsZero) - g2single(tauIsZero));

end

