function [Code_Rate_UE, Qm] = UE2CodeRate(n_UE)
R = 500;
d_2D = R*rand([n_UE,1])+10;
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
        PL(i) = 22*log10(d_3D(i)) + 28.0 + 20*log10(fc) + normrnd(0,3);
    else
        PL(i) = 40*log10(d_3D(i))+28.0+ 20*log10(fc) - 9*log10((d_BP)^2+(h_BS - h_UT)^2) + normrnd(0,3);
    end
end
Pr = Pt- PL;
BW = 10e6; %10MHz (50RB), Table 8.2-2
T0 = 300;
k_bolt = 1.38*10^(-23);
P_noise = k_bolt*T0*BW;
SNR = db2pow(Pr)/P_noise;
SNR_dB = pow2db(SNR);

CQI_UE = SNR2CQI(SNR_dB);
Qm = CQI2mod_scheme(CQI_UE);


    function CQI = SNR2CQI(SNR_dB)
        CQI = zeros(1,length(SNR_dB));
        for snr=1:length(SNR_dB)
            if SNR_dB(snr)>29
                CQI(snr) = 15;
            elseif SNR_dB(snr)>27.30
                CQI(snr) = 14;
            elseif SNR_dB(snr)>25
                CQI(snr) = 13;
            elseif SNR_dB(snr)>23.45
                CQI(snr) = 12;
            elseif SNR_dB(snr)>21.50
                CQI(snr) = 11;
            elseif SNR_dB(snr)>19.90
                CQI(snr) = 10;
            elseif SNR_dB(snr)>17.90
                CQI(snr) = 9;
            elseif SNR_dB(snr)>16.00
                CQI(snr) = 8;
            elseif SNR_dB(snr)>14.05
                CQI(snr) = 7;
            elseif SNR_dB(snr)>11.95
                CQI(snr) = 6;
            elseif SNR_dB(snr)>10.00
                CQI(snr) = 5;
            elseif SNR_dB(snr)>8
                CQI(snr) = 4;
            elseif SNR_dB(snr)>6
                CQI(snr) = 3;
            elseif SNR_dB(snr)>4
                CQI(snr) = 2;
            elseif SNR_dB(snr)>1.95
                CQI(snr) = 1;
            else
                CQI(snr) = 0;
            end
        end
    end

    function bps = CQI2mod_scheme(CQI)
        bps = zeros(1,length(CQI));
        for cqi = 1:length(CQI)
            if CQI(cqi)<=6 && CQI(cqi)>0
                bps(cqi) = 2; %QPSK
            elseif CQI(cqi)<=9
                bps(cqi) = 4; %16-QAM
            elseif CQI(cqi)<=15
                bps(cqi) = 6; %64-QAM
            else
                bps(cqi) = 0;
            end
        end
    end

    function Code_Rate = CQI2Code_rate(CQI)
        cqi2coderate_map = importdata('CQI_2_coderate.csv');
        Code_Rate = zeros(length(CQI),1);
        %Look-up table MATLAB
        % Code_Rate = fixpt_interp1(cqi2coderate_map(:,1),cqi2coderate_map(:,2), CQI,sfix(8),2^3,'Floor');
        for cqi = 1:length(CQI)
            Code_Rate(cqi) = cqi2coderate_map(CQI(cqi),2);
        end
    end
    Code_Rate_UE = CQI2Code_rate(CQI_UE);
end

