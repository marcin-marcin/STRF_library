%
%function [spet]=shufflerandspet(spet,Fs,T)
%
%   FILE NAME       : SHUFFLE RAND SPET
%   DESCRIPTION     : Shuffle a 'spet' variable with Poisson intervals
%                     and same number of spikes as the original spet
%
%   spet            : Array of spike event times
%   Fs              : Sampling rate (Hz)
%   T               : Duration for spike event time array
%
function [spet]=shufflerandspet(spet,Fs,T)

%Generating Random SPET array
spet=sort(ceil(Fs*T*rand(1,length(spet))));