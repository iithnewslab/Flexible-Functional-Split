clear all;

close all;
clc;
global power_LTE;
global no_UE;
no_UE = 50;
global no_eNB;
no_eNB = 4;
global t;
global PLM_linear;
global PLM_wifi_linear rssi;
t =4;
% UE = rand(100,2)*50; % UE postion Between 0,0 and 1000,1000
% UE = [24 22 6; 8 32 6];
UE = zeros(no_UE,3);
UE(:,1) = rand(no_UE,1)*50;
UE(:,2) = rand(no_UE,1)*50;
UE(:,3) = rand(no_UE,1)*10;
eNB = [10 20 4; 35 41 1; 25 25 7; 40 10 7];

power_LTE = [16 16 16 16];
power_wifi = [20 20 20 20];

% Calculate distance betwwen UE and eNB
dis = zeros(no_eNB, no_UE);
no_wall_x = zeros(no_eNB, no_UE);
no_wall_y = zeros(no_eNB, no_UE);
no_wall_z = zeros(no_eNB, no_UE);

no_UE_asso = zeros(1,no_eNB);

for i = 1:no_eNB
    for j= 1:no_UE
        dis(i, j) = norm(UE(j,:) - eNB(i,:));
        % calculate no walls crossed in X direction, every wallls appear at
        % 5m away
        no_wall_x(i,j) = abs( fix(UE(j,1) / 5) - fix((eNB(i,1) / 5))) ; 
        % calculate no walls crossed in Y direction every wall appear 10 m
        % apart
        no_wall_y(i,j) = abs( fix(UE(j,2) / 10) - fix((eNB(i,2) / 10))) ; 
        % calculate no Floors crossed in z direction floors are 5m apart
        no_wall_z(i,j) = abs( fix(UE(j,3) / 5) - fix((eNB(i,3) / 5))) ; 
    end
end

for l = 1: no_UE
    [M,I] = min(dis(:,l));
    no_UE_asso(1,I) = no_UE_asso(1,I) + 1;
end
no_UE_asso
assign_LTE_power = zeros(1,no_eNB);
assign_Wifi_power = zeros(1,no_eNB);
for j =1 : no_eNB
    assign_LTE_power(1,j) = max(min(((no_UE_asso(1,j)/no_UE) * 92) ,23) , 16);
    assign_Wifi_power(1,j) = max(min(((no_UE_asso(1,j)/no_UE) * 80) ,20) , 10);
end
assign_LTE_power
assign_Wifi_power


% calculate Pathloss using Indoor Pathloss Model with respect to each UE
% and eNB

PLM = zeros(no_eNB, no_UE);
RSRP = zeros(no_eNB, no_UE);
RSRP_linear = zeros(no_eNB, no_UE);
for i =1 : no_eNB
    for j= 1: no_UE
        k = 1 + no_wall_z(i,j);
        n = no_wall_x(i,j) + no_wall_y(i,j);
        PLM(i,j) = 37 + 30 * log10(dis(i,j)) + 18.3 * k ^ ((k +2) / ((k +1) - 0.46)) + (n * 5) ;
        PLM_linear(i,j) = dB2linear(PLM(i,j));
        r_linear(i,j) = dB2linear(power_LTE(i)) / PLM_linear(i,j);
        k_r_linear(i,j) = dB2linear(assign_LTE_power(i)) / PLM_linear(i,j);
        RSRP(i,j) = power_LTE(i) - PLM(i,j);
        k_RSRP(i,j) = assign_LTE_power(i) - PLM(i,j);
        RSRP_linear(i,j) = dB2linear(RSRP(i,j));
        k_RSRP_linear(i,j) = dB2linear(k_RSRP(i,j));
    end
end
global total_noise;
% calculate Noise
Temperature = 290; % Kelvin
k = 1.3806488*10^-23; % Boltzman Constant
BW = 9*1e6; % Efective Bandwidth of channel (9 MHz)
ue_noise_figure = 7 ; % 7 dB noise figure is considered
noise = linear2dB(k * Temperature * BW);
total_noise_dBm = ue_noise_figure + noise;
total_noise = 10 ^ (total_noise_dBm/10);
noise_dB= linear2dB(total_noise);

%Calculate Sinr
sinr = zeros(no_eNB, no_UE);
sinr_dB = zeros(no_eNB, no_UE);
for i = 1 : no_UE
    for j = 1: no_eNB
        sinr(j,i) = RSRP_linear(j,i) / (sum(RSRP_linear(:,i)) - RSRP_linear(j,i) + total_noise);
        k_sinr(j,i) = k_RSRP_linear(j,i) / (sum(k_RSRP_linear(:,i)) - k_RSRP_linear(j,i) + total_noise);
        sinr_dB(j,i) = linear2dB(sinr(j,i));
        k_sinr_dB(j,i) = linear2dB(k_sinr(j,i));
    end
end

% Calculate Pathloss model for wifi
PLM_wifi = zeros(no_eNB, no_UE);
rssi = zeros(no_eNB, no_UE);
rssi_linear = zeros(no_eNB, no_UE);
for i =1 : no_eNB
    for j= 1: no_UE
        n = no_wall_x(i,j) + no_wall_y(i,j) + no_wall_z(i,j);
        f = 2400; % frequency in MHz
        N = 30; % for office scenario
        PLM_wifi(i,j) = 20 * log10(f) + N * log10(dis(i,j)) + (15 + 4 * (n-1)) -28;
        PLM_wifi_linear(i,j) = dB2linear(PLM_wifi(i,j));
        rssi(i,j) = power_wifi(i) - PLM_wifi(i,j);
        k_rssi(i,j) = assign_Wifi_power(i) - PLM_wifi(i,j);
        rssi_linear(i,j) = dB2linear(rssi(i,j));
        k_rssi_linear(i,j) = dB2linear(k_rssi(i,j));
    end
end

% calculate SNR for wifi 
snr = zeros(no_eNB, no_UE);
snr_dB = zeros(no_eNB, no_UE);
for i = 1 : no_UE
    for j = 1: no_eNB
        snr(j,i) = rssi_linear(j,i) /(sum(rssi_linear(:,i)) - rssi_linear(j,i) + total_noise);
        k_snr(j,i) = k_rssi_linear(j,i) /(sum(k_rssi_linear(:,i)) - k_rssi_linear(j,i) + total_noise);
        snr_dB(j,i) = linear2dB(snr(j,i));
        k_snr_dB(j,i) = linear2dB(k_snr(j,i));
    end
end
% 
% cdfplot(max(sinr_dB));
% hold on;
% cdfplot(max(snr_dB));
% hold on;
y = fmincon_linear_wifi();
x = fmincon_linear();
% x = fmincon_IBx();
sum_rssi_wifi = zeros(no_eNB,no_UE);
for i =1 : no_eNB
    for j= 1: no_UE
%         r_linear(i,j) = dB2linear(x(i + (2 * no_eNB * no_UE))) / PLM_linear(i,j);
        sum_rssi_wifi(i,j)= dB2linear(y(i + ( no_eNB * no_UE))) / PLM_wifi_linear(i,j);
         r_linear(i,j) = dB2linear(x(i + (no_eNB * no_UE))) / PLM_linear(i,j);
%         sum_rssi_wifi(i,j) = dB2linear(x(i + (2 * no_eNB * no_UE) + no_eNB)) / PLM_wifi_linear(i,j);
    end
end
o =0;
l =0;
n =0;
global sinr_eachUE snr_eachUE rssi_eachUE asso_lte asso_wifi;
sinr_eachUE = zeros(1,no_UE);
rssi_eachUE = zeros(1,no_UE);
snr_eachUE = zeros(1,no_UE);
for i = 1 : no_UE
    for j = 1: no_eNB
%         (no_eNB * i) - mod(j,no_eNB)
%         x(j + l)
        sinr_opti(j,i) = (r_linear(j,i) / (sum(r_linear(:,i)) - r_linear(j,i) + total_noise));
        snr_opti(j,i) = ( sum_rssi_wifi(j,i) / (sum(sum_rssi_wifi(:,i)) - sum_rssi_wifi(j,i) + total_noise));
%         o =o +  ((x(j + l)) * (sinr_opti(j,i)));
%         n =n +  ((y(j + l)) * (snr_opti(j,i)));
%         o;
        sinr_opti_dB(j,i) = linear2dB(sinr_opti(j,i));
        snr_opti_dB(j,i) = linear2dB(snr_opti(j,i));  
        
        if(x(j + l) >= 0.9 && sinr_opti_dB(j,i) >= 3)
            asso_lte(j,i) = 1;
            sinr_eachUE(1,i) = sinr_opti_dB(j,i);
        elseif(sinr_opti_dB(j,i) <= 3)
            asso_lte(j,i) = 0;
        end
        
    end
    l = i * j;
end
q=0;
for i = 1 : no_UE
    for j = 1: no_eNB
        if(asso_lte(j,i) == 1 && snr_opti_dB(j,i) >= 1 && y(j+l) >=0.9)
            asso_wifi(j,i) =1;
            rssi_eachUE(1,i) = y(j + (no_UE * no_eNB)) - PLM_wifi(j,i);
            snr_eachUE(1,i) = snr_opti_dB(j,i);
        elseif(asso_lte(j,i) < 1 && snr_opti_dB(j,i) >=1 && max(asso_lte(:,i)) < 1)
            asso_wifi(j,i) = 1;
            rssi_eachUE(1,i) = y(j + (no_UE * no_eNB)) - PLM_wifi(j,i);
            snr_eachUE(1,i) = snr_opti_dB(j,i);
        else
            asso_wifi(j,i) =0;
        end
    end
    l = i * j;
end


% figure1 = figure(1);
% % x
% % y
% 
% 
cdfplot(max(sinr_dB));
hold on;
cdfplot(max(k_sinr_dB));
hold on;
cdfplot(max(sinr_opti_dB))
hold on;
cdfplot(max(snr_dB));
hold on;
cdfplot(max(k_snr_dB));
hold on;
cdfplot(max(snr_opti_dB))
% 
% 
% title('C.D.F. of SINR Distribution');
% xlabel('SINR(dB)'); % x-axis label
% ylabel('Probabilty of SINR'); % y-axis label
% legend('Traditional SINR','Optimized SINR', ...
%     'Traditional SNR','Optimized SNR');
% saveas(figure1,[pwd '/cdf_cluster_sinr_mhcpp2.jpg']);
% hold off;
% cdfplot(max(sinr_opti_dB));
% hold on;
% cdfplot(max(snr_opti_dB));
% o