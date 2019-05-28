%% function [FTCStats] = ftccentroid(FTC)%%	FILE NAME 	: FTC CENTROID%	DESCRIPTION : Computes the centroid (mean), standard deviation, and %                 skewness of an FTC at each SPL (log frequency)%%	FTC	        : Tunning Curve Data Structure%                   FTC.Freq                - Frequency Axis%                   FTC.Level               - Sound Level Axis (dB)%                   FTC.data                - Data matrix%% RETURNED DATA%%   FTCstats    : FTC statistics Data Structure%	                Mean     - Mean Frequency (in Hz; computed in octave)%                   Std      - Standard Deviation%                   Skewness - Skewness%function [FTCStats] = ftccentroid(FTC)%Computing MeanData=FTC.data;   X=log2(FTC.Freq/min(FTC.Freq));FTCStats.Mean=Data'*X'./sum(Data)';FTCStats.Mean=min(FTC.Freq)*2.^(FTCStats.Mean);%Computing Standard DeviationXX=ones(length(FTCStats.Mean),1)*X - log2(FTCStats.Mean/min(FTC.Freq))*ones(size(X));FTCStats.Std=sqrt( sum(Data'.*XX.^2,2) ./sum(Data)' ) ;