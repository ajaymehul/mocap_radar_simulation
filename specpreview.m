
function Specpreview(File)

% --------- File Name ---------
data_Name = [File];% reads the file 
data_Name = [data_Name,'.dat'];
% --------- Data Load ---------
fileID = fopen(data_Name, 'r');
dataArray = textscan(fileID, '%f');
fclose(fileID);
radarData = dataArray{1};
clearvars fileID dataArray ans;
% Center frequency (fc)
fc = radarData(1); 
% Sweep time in ms
Tsweep = radarData(2)*1e-3; 
% Number of time samples per sweep
NTS = radarData(3); 
% FMCW Bandwidth. For FSK, it is frequency step;
Bw = radarData(4); 
% Speed of light
c = 3e8;
% raw data in I+j*Q format
Data = radarData(5:end); 
% Time
time = Tsweep * length(Data)/NTS;
% Sampling rate
samp_rate = 1/Tsweep*NTS*1000;
Np = floor(size(Data,1)/NTS);
%--------- IQ imbalance correction ---------
I_rawdata = real(Data)-mean(real(Data));
Q_rawdata = imag(Data)-mean(imag(Data));
NN = Np*NTS;
ND = Np;
NN4 = floor(NN/ND);
for k=1:NN4
    Data((k-1)*ND+1:(k-1)*ND+ND,1) = ...
        IQcorrection(I_rawdata((k-1)*ND+1:(k-1)*ND+ND,1),...
                     Q_rawdata((k-1)*ND+1:(k-1)*ND+ND,1));
end

%%  FMCW - Micro-Doppler
Col = floor(length(Data)/NTS);
% --------- Arrange raw Data ---------
Raw_Data = reshape(Data,NTS,Col);
% --------- DC subtraction ---------
Raw_Data = Raw_Data - repmat(mean(Raw_Data,2),[1,size(Raw_Data,2)]);
G0 = Raw_Data;
np = size(G0,2);
rngpro = fftshift(fft(G0),1);
% --------- Variables  ---------
dp = Tsweep;
% Pulse Repetition Frequency (PRF)
prf = 1/dp;
% Indexed Doppler frequency
F = linspace(-prf/2,prf/2,np);
rngpro0 = rngpro(:,1:np);
% ---------Raw Doppler data ---------
%f = sum(rngpro0);
f = sum(rngpro0(50:80,:)); % cafer - select range
% --------- Time-Frequency Function ---------
window = 128;
noverlap = 90; %120
nfft = 1024;  %1024
% STFT % sspec: Complex spectrogram
sspec = spectrogram(f,window,noverlap,nfft); 
% -------------------------------------------

% Plot the micro Doppler signatures
time = Tsweep * length(Data)/NTS;
MDS = figure('Name', 'FullscreenTest');
colormap(jet(512));
% sspec is the spectrogram
imagesc([0 time],[-prf/2 prf/2],20*log10(abs(fftshift(sspec,1)/max(max(abs(sspec))))));
axis xy
set(gca,'FontSize',15)
title(data_Name);
xlabel('Time (sec)');
ylabel('Frequency (Hz)');
caxis([-40 0])

end