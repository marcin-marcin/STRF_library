%
%function []=vripplebincon(outfile,f1,f2,Fm1,Fm2,FM,RD,M,Fs,NS,MinCorr,MaxCorr,RP)
%
%	FILE NAME 	: V RIPPLE BIN CON
%	DESCRIPTION 	: Binaural Virtual Ripple Sound
%			  Generated by controling the correlated activity
%			  across contra and ipsi ears
%			  The correlation activity between contra and ipsi
%			  can vary continously between zero and one
%
%			  CONTINOUS CORRELATION MAP
%			  CONTINOUS TEMPORAL MODULATIONS
%
%	outfile		: Output File Name - No Extension
%	f1		: Minimum Carrier Frequency
%	f2		: Maximum Carrier Frequency
%	Fm1		: Minimum temporal modulation rate
%	Fm2		: Maximum temporal modulation rate
%	FM		: Ripple temporal modulation rate
%	RD		: Ripple density
%       M               : Number of Samples
%       Fs              : Sampling Rate
%	NS		: Number of sinusoid carriers
%	MinCorr		: Minimum Correlation Coefficient
%	MaxCorr		: Maximum Correlation Coefficient
%	RP		: Ripple Phase [0,2*pi]
%			  Default : Choosen randomly
%
function []=vripplebincon(outfile,f1,f2,Fm1,Fm2,FM,RD,M,Fs,NS,MinCorr,MaxCorr,RP)

%Input Arguments
if nargin<13
	RP=2*pi*rand;
end

%Octave Frequency Axis
XMax=log2(f2/f1);
X=(0:NS-1)/(NS-1)*XMax;
faxis=f1*2.^X;

%Generating Temporary Envelope
EnvTemp=noiseunifh(Fm1,Fm2,Fs,M*4);

%Generating Contra and Ipsi Sound Sequence
X1=zeros(1,M);
X2=zeros(1,M);
S=0
for k=1:NS

	%Display Output
	clc
	disp(['Generating Carrier: ' int2str(k) ' of ' int2str(NS)])

	%Generating Correlation Envelope
	r=.5*(MaxCorr-MinCorr)*(1+sin(2*pi*RD*X(k)+2*pi*FM*(1:M)/Fs+RP))+MinCorr;

	%Temporal Envelopes
	N1=round(rand*2.9*M);
	N2=round(rand*2.9*M);
	EnvComon=EnvTemp(N1+1:N1+M);
	EnvRand =EnvTemp(N2+1:N2+M);

	%Contra and Ipsi Envelopes
	a= ( 1-sqrt(1./r.^2-1) ) ./ (2-1./r.^2);
	Env1=EnvComon;
	Env2=EnvComon.*a+EnvRand.*(1-a);

	%Random Phase
	P=2*pi*rand;

	%Contra and Ipsi Sounds
	X1=X1+Env1.*sin(2*pi*faxis(k)*(1:M)/Fs+P);
	X2=X2+Env2.*sin(2*pi*faxis(k)*(1:M)/Fs+P);

end

%Combining Contra and Ipsi Sounds
X=zeros(1,2*length(X1));
X(1:2:length(X))=X1;
X(2:2:length(X))=X2;

%Writing Output
fid=fopen([outfile '.sw'],'w');
fwrite(fid,round(0.9*X/max(X)*1024*32),'int16');

%Converting to WAV file
outfile2=[outfile '.wav'];
f=['!sox -r ' int2str(Fs) ' -c 2 ' outfile '.sw ' outfile2];
eval(f)                                                                           
