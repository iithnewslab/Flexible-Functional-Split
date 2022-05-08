% format long
run Dynamic_BW_dynamic_split_5G_V2.m
n_DU = 10;
% BW
BW_max = 4000*n_DU; %Gbps
duration = 240;
BW_used = zeros(duration,1);
n_DU_centralized = zeros(duration,1);
DU_hourly_split = zeros(duration,n_DU);
n_DU_centralized_time = zeros(duration,n_DU);
n_split_options = 6;
t = linspace(0,239,duration);
run 'Data (Hourly)'/Data_Read.m

%run 'Data (Hourly)'/Data_Read_2018b.m


data_Rate = [T1(:,2)';T2(:,2)';T3(:,2)';T4(:,2)';T5(:,2)';T6(:,2)';T7(:,2)';T8(:,2)';T9(:,2)';T10(:,2)'];

w0 = [133, 5640 3760, 1880, 7520, 9400];
Aeq = zeros(n_DU, 2*n_DU); % Cosntraints % zeros(2*n_DU,1);
beq = zeros(n_DU,1);
A = zeros(2*n_DU,1);
b = BW_max;
%%
for tti = 1:duration
    
    UT = data_Rate(:,tti);
    f = [UT; (ones(n_DU,1)+UT)]; %sigma(UT*x+w)
    %     f = [UT; ones(n_DU,1)]; %sigma(UT*x+w)
    f = reshape(f,[1,2*n_DU]);
    
    A = [UT; ones(n_DU,1)];
    A = reshape(A,[1,2*n_DU]);
    b = BW_max;
    
    %     A = f;
    %     b = BW_max;
    
    %     intcon = 2*n_DU;
    intcon = [1:n_DU];
    ub = zeros(2*n_DU,1);
    lb = zeros(2*n_DU,1);
    for u = 1:n_DU
        if UT(u) > 3200
            ub(u)=1;
            ub(u+n_DU) = w0(6);
            lb(u)=0;
            lb(u+n_DU) = w0(1);
            % w = x*w0(1) + (1-x)*w0(6)
            Aeq(u,u) = w0(1) - w0(6); %coefficient of x
            Aeq(u,u+n_DU) = -1; %coefficient of w
            beq(u) = -w0(6);
            
            
        elseif UT(u) > 2400
            ub(u)=1;
            ub(u+n_DU) = w0(5);
            lb(u)=0;
            lb(u+n_DU) = w0(1);
            % w = x*w0(1) + (1-x)*w0(5)
            Aeq(u,u) = w0(1) - w0(5); %coefficient of x
            Aeq(u,u+n_DU) = -1; %coefficient of w
            beq(u) = -w0(5);
            
            
        elseif UT(u) > 1600
            ub(u)=1;
            ub(u+n_DU) = w0(2);
            lb(u)=0;
            lb(u+n_DU) = w0(1);
            
            % w = x*w0(1) + (1-x)*w0(2)
            Aeq(u,u) = w0(1) - w0(2); %coefficient of x
            Aeq(u,u+n_DU) = -1; %coefficient of w
            beq(u) = -w0(2);
            
        elseif UT(u) > 800
            ub(u)=1;
            ub(u+n_DU) = w0(3);
            lb(u)=0;
            lb(u+n_DU) = w0(1);
            
            % w = x*w0(1) + (1-x)*w0(3)
            Aeq(u,u) = w0(1) - w0(3); %coefficient of x
            Aeq(u,u+n_DU) = -1; %coefficient of w
            beq(u) = -w0(3);
            
        else
            ub(u)=1;
            ub(u+n_DU) = w0(4);
            lb(u)=0;
            lb(u+n_DU) = w0(1);
            
            % w = x*w0(1) + (1-x)*w0(4)
            Aeq(u,u) = w0(1) - w0(4); %coefficient of x
            Aeq(u,u+n_DU) = -1; %coefficient of w
            beq(u) = -w0(4);
            
        end
    end
    x = intlinprog(-f,intcon,A,b,Aeq,beq,lb,ub);
    BW_used(tti) = sum(UT.*x(1:n_DU),"all") + sum(x(n_DU+1:end),"all");
    n_DU_centralized(tti) = length(find(~x(1:n_DU)));
    n_DU_centralized_time(tti,:) = x(n_DU+1:end);
    for du = 1:n_DU
        DU_hourly_split(tti,du) = x(n_DU+du);
    end
end

BW_used_percentage = BW_used*100/BW_max;
n_DU_centralized_percentage = n_DU_centralized*100/n_DU;

%% For Fixed Split
BW_used_fixed_split_6 = data_Rate+133;
BW_used_fixed_split_6_percentage = sum(BW_used_fixed_split_6,1)*100/BW_max;

BW_used_fixed_split_2 = data_Rate+16;
BW_used_fixed_split_2_percentage = sum(BW_used_fixed_split_2,1)*100/BW_max;

f = figure;
plot(interp(BW_used_percentage(24:48),5),'Linewidth',2)
hold on
plot(interp(BW_used_fixed_split_6_percentage(24:48),5),'Linewidth',2)
plot(interp(BW_used_fixed_split_2_percentage(24:48),5),'Linewidth',2)
xlabel("t (24 Hours)")
% ylim([0 105])
% xlim([0 24])
ylabel("BW used(%)")
xticks(0:25:125)
xticklabels(0:5:25)
yline(10*9400*100/BW_max,'-','Fixed split (Option-7)','LineWidth',2, 'Color', 'k')
% yline(100,'-','Max BW (%)', 'Color', 'r')
legend("Dynamic Split", "Fixed split (Option-6)", "Fixed split (Option-2)",'Fixed split (Option-7)','Location','northeastoutside')
xlim([0 25*5-1])
% xticks(25*5-1)
grid minor
hold off

% figure
% plot(t,n_DU_centralized_percentage,'Linewidth',2)
% xlabel("t (24 Hours)")
% ylabel("BW used(%)")
% xlim([0 240])

%% Plot: UT vs Centralization
traffic_cumulative = sum(data_Rate,1);
subplot(2,1,1);
% plot(t(1:24),traffic_cumulative(1:24))
plot(traffic_cumulative(24:55),'Linewidth',2)
xlim([1 32])
xlabel("Real time (hours)")
ylabel(["Total traffic";"(Mbps)"])
xticklabels([5,10,15,20,1,6])
grid on
grid minor
set(gca,'FontSize',20)
% ylim([0 10])

subplot(2,1,2); 
% stairs(t(1:24),n_DU_centralized(1:24))
stairs(n_DU_centralized(24:55),'Linewidth',2)
xlim([1 32])
ylim([0 11])
xticklabels([5,10,15,20,1,6])
yticks(0:2:10)
xlabel("Real time (hours)")
ylabel({'DUs running';'at Option-7'}) %"Total DUs running \n at Option-7")
grid on
grid minor
set(gca,'FontSize',20)
% stairs(t,n_DU_centralized)
%% Bar Plot
% y_bar = zeros(n_DU,2);
% for i = 1:duration
%     y_bar(i,1) = n_DU_centralized(i);
%     y_bar(i,2) = n_DU - n_DU_centralized(i);
%
% end
%
% bar(y_bar,'stacked')

%% DU Centralization Time
DU_split_time = zeros(n_DU, n_split_options); %For how long a DU is running at a particular option
n_DU_centralized_time = round(n_DU_centralized_time);
for i = 1:n_DU
    DU_split_time(i,1) = length(find(~(n_DU_centralized_time(:,i) - 133)));
    DU_split_time(i,2) = length(find(~(n_DU_centralized_time(:,i) - 1880)));
    DU_split_time(i,3) = length(find(~(n_DU_centralized_time(:,i) - 3760)));
    DU_split_time(i,4) = length(find(~(n_DU_centralized_time(:,i) - 5640)));
    DU_split_time(i,5) = length(find(~(n_DU_centralized_time(:,i) - 7520)));
    DU_split_time(i,6) = length(find(~(n_DU_centralized_time(:,i) - 9400)));
    
end

%Bar Plot: Centralization Time
figure
bar(DU_split_time*100/240,'stacked')
legend('Option-6', 'Option-7 (20MHZ)', 'Option-7 (40MHZ)', 'Option-7 (60MHZ)','Option-7 (80MHZ)','Option-7 (100MHZ)','Location','northeastoutside',"Orientation","vertical")
xlabel('DU')
ylabel('time (240 Hours/ 10 Days)')

%% Total centralization
total_centralization = zeros(n_split_options,1);
for i = 1:n_DU
total_centralization(1) = total_centralization(1) + length(find(~(n_DU_centralized_time(:,i) - 133)));
total_centralization(2) = total_centralization(2) + length(find(~(n_DU_centralized_time(:,i) - 1880)));
total_centralization(3) = total_centralization(3) + length(find(~(n_DU_centralized_time(:,i) - 3760)));
total_centralization(4) = total_centralization(4) + length(find(~(n_DU_centralized_time(:,i) - 5640)));
total_centralization(5) = total_centralization(5) + length(find(~(n_DU_centralized_time(:,i) - 7520)));
total_centralization(6) = total_centralization(6) + length(find(~(n_DU_centralized_time(:,i) - 9400)));
end
%% Plot
figure
options = {'Option-6','Option-7 (20MHZ)', 'Option-7 (40MHZ)', 'Option-7 (60MHZ)','Option-7 (80MHZ)','Option-7 (100MHZ)'};
bar(total_centralization*100/sum(total_centralization),'stacked','FaceColor',[0.75 0.75 0.75])
set(gca,'xticklabel',options)
xtickangle(45)
ylabel('Total Duration of splits (%)')
% legend('Option-6', 'Option-7 (20MHZ)', 'Option-7 (40MHZ)', 'Option-7 (60MHZ)','Option-7 (80MHZ)','Option-7 (100MHZ)','Location','northeastoutside',"Orientation","vertical")

%% At what hour system is more centralized?

Hourly_centralozation = zeros(24,n_split_options);
% for t = 1:duration
%     Hourly_centralozation(mod(t,24)) = Hourly_centralozation(mod(t,24)) + 
% end
for i = 1:duration
    t = mod(i-1,24) + 1;
    
Hourly_centralozation(t,1) = Hourly_centralozation(t,1) + length(find(~(n_DU_centralized_time(i,:) - 133)));
Hourly_centralozation(t,2) = Hourly_centralozation(t,2) + length(find(~(n_DU_centralized_time(i,:) - 1880)));
Hourly_centralozation(t,3) = Hourly_centralozation(t,3) + length(find(~(n_DU_centralized_time(i,:) - 3760)));
Hourly_centralozation(t,4) = Hourly_centralozation(t,4) + length(find(~(n_DU_centralized_time(i,:) - 5640)));
Hourly_centralozation(t,5) = Hourly_centralozation(t,5) + length(find(~(n_DU_centralized_time(i,:) - 7520)));
Hourly_centralozation(t,6) = Hourly_centralozation(t,6) + length(find(~(n_DU_centralized_time(i,:) - 9400)));
end

%% Bar Plot: Hourly Analysis
hour = linspace(0,23,24);
bar(hour,Hourly_centralozation,'stacked')
legend('Option-6', 'Option-7 (20MHZ)', 'Option-7 (40MHZ)', 'Option-7 (60MHZ)','Option-7 (80MHZ)','Option-7 (100MHZ)','Location','northeastoutside',"Orientation","vertical")
xlabel('t (24-Hours)')
ylabel('DUs running at paticular Split(%)')

%% Total Hourly Analysis
Hourly_centralozation_1 = sum(Hourly_centralozation(:,2:end),2);

plot(hour, Hourly_centralozation_1, 'Linewidth',2);
grid on
xlim([0 23])
ylim([0 105])
xlabel('t (24-Hours)')
ylabel('DUs centralized (%)')
% title("Percentage Centralization of DUs at different hour of time")

%% Plot: Realtime (Hourly) Analysis of each DU (Plot For one DU only)
%%% Plot For one DU only
DU_hourly_split_3  = DU_hourly_split(:,3);

DU_hourly_split_3 = repmat(DU_hourly_split_3', 5, 1);
DU_hourly_split_3 = DU_hourly_split_3(:)';

% DU_hourly_split_3 = reshape(DU_hourly_split_3, [])
Data_DU_3 = data_Rate(3,:);
Data_DU_3 = interp(Data_DU_3,5);
for i = 1:duration*5
    if round(DU_hourly_split_3(i)) == 133
       DU_hourly_split_3(i) = DU_hourly_split_3(i) + Data_DU_3(i);
    end
end

figure
plot(Data_DU_3(1:24*5*10),'LineWidth',2)
hold on
plot(DU_hourly_split_3(1:24*5*10),'LineWidth',2)

% plot(Data_DU_3(1:24*5))
% xticks(0:5:240*10)
xticks(12*5:24*5:240*5)
% xticklabels(0:24*10)
xticklabels({'Mon','Tue', 'Wed', 'Thu','Fri','Sat', 'Sun','Mon','Tue', 'Wed'})
xtickangle(45)
% xlabel("time (hours)")
ylabel("Traffic on the Midhaul")
yline(IntraPHY_20MHz(1),'--','7-20MHz')
yline(IntraPHY_40MHz(1),'--','7-40MHz')
yline(IntraPHY_60MHz(1),'--','7-60MHz')
yline(IntraPHY_80MHz(1),'--','7-80MHz')
yline(IntraPHY_100MHz(1),'--','7-100MHz')
ylim([-100 10000])
legend('User Traffic','Adaptive Split','Location','northwest')

%% Plot: Realtime (Hourly) Analysis of each DU (Plot For one 3 DUs)
for i = 1:duration
    for j = 1:n_DU        
        if round(DU_hourly_split(i,j)) == 133
            DU_hourly_split(i,j) = DU_hourly_split(i,j) + data_Rate(j,i);
        end
    end
end

% set(gca,'DefaultLineLineWidth',1.5)

DU_hourly_split_1 = repmat(DU_hourly_split(:,1)', 5, 1);
DU_hourly_split_1 = DU_hourly_split_1(:)';

plot(DU_hourly_split_1(1:240),'LineWidth',2)
hold on

DU_hourly_split_2 = repmat(DU_hourly_split(:,2)', 5, 1);
DU_hourly_split_2 = DU_hourly_split_2(:)';
plot(DU_hourly_split_2(1:240),'LineWidth',2)

DU_hourly_split_3 = repmat(DU_hourly_split(:,3)', 5, 1);
DU_hourly_split_3 = DU_hourly_split_3(:)';
plot(DU_hourly_split_3(1:240),'LineWidth',2)

ylabel("Traffic on the Midhaul")
yline(IntraPHY_20MHz(1),'--','7-20MHz')
yline(IntraPHY_40MHz(1),'--','7-40MHz')
yline(IntraPHY_60MHz(1),'--','7-60MHz')
yline(IntraPHY_80MHz(1),'--','7-80MHz')
yline(IntraPHY_100MHz(1),'--','7-100MHz')
xticks(0:50:250)
xticklabels(0:5:25)
xlabel("time (in Hours)")
% xtickangle(45)
legend('DU_1','DU_2', 'DU_3', 'Location','northwest')
ylim([-100 10000])
% set(gca,'LineWidth',2)

hold off
