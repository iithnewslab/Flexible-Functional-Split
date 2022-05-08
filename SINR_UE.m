function SNR_dB = SINR_UE(n_UE)
R = 500;
d_2D = R*rand([n_UE,1])+10; %min d_2D is 10m;
% theta = -pi + 2*pi*rand(n_UE,1);
% scatter(r.*cos(theta), r.*sin(theta));
h_BS = 10;
h_UT = 1.5; %
fc  =  2; %center frequency = 2GHz
c = 3e8; %speed of light
d_BP = 4*(h_BS-1)*(h_UT-1)*fc/c; %Break point distance
d_3D = sqrt(d_2D.^2 + h_BS^2);
% Pt = 10^((43-30)/10); %Transmit power of BS; 43dBm
Pt = 41-30; %dB, 41dBM, Table 6-1
%---3GPP TR 36.873 V12.7.0, Table 7.2-1: Pathloss models
% 3D-UMi scenario
PL = []; %path loss
sigma_SF = 3; %dB, Shadow fading
for i=1:length(d_2D)
    if(d_2D(i)<d_BP)
        PL(i) = 22*log10(d_3D(i)) + 28.0 + 20*log10(fc) + normrnd(0,sigma_SF);
    else
        PL(i) = 40*log10(d_3D(i))+28.0+ 20*log10(fc) - 9*log10((d_BP)^2+(h_BS - h_UT)^2) + normrnd(0,sigma_SF);
    end
end

% Pt-Pr = pathloss
Pr = Pt- PL;
BW = 10e6; %10MHz (50RB), Table 8.2-2
T0 = 300;
k_bolt = 1.38*10^(-23);
P_noise = k_bolt*T0*BW;
SNR = db2pow(Pr)/P_noise;
SNR_dB = pow2db(SNR);

end