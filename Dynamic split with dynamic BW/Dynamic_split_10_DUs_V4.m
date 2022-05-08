% format long
n_DU = 10;
BW_max = 4200*n_DU; %Gbps
duration = 240;
BW_used = zeros(duration,1);
n_DU_centralized = zeros(duration,1);
n_DU_centralized_time = zeros(duration,n_DU);
n_split_options = 6;
t = linspace(0,239,duration);
run 'Data (Hourly)'/Data_Read.m

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
end

BW_used_percentage = BW_used*100/BW_max;
n_DU_centralized_percentage = n_DU_centralized*100/n_DU;

%% For Fixed Split
BW_used_fixed_split_6 = data_Rate+133;
BW_used_fixed_split_6_percentage = sum(BW_used_fixed_split_6,1)*100/BW_max;

BW_used_fixed_split_2 = data_Rate+16;
BW_used_fixed_split_2_percentage = sum(BW_used_fixed_split_2,1)*100/BW_max;

f = figure;
plot(t,BW_used_percentage,'Linewidth',2)
hold on
plot(t,BW_used_fixed_split_6_percentage,'Linewidth',2)
plot(t,BW_used_fixed_split_2_percentage,'Linewidth',2)
xlabel("t (240 Hours/ 10 Days)")
% ylim([0 100])
xlim([0 240])
ylabel("BW used(%)")
legend("Dynamic Split", "Fixed split (Option-6)", "Fixed split (Option-2)",'Location','northeastoutside')
hold off

figure
plot(t,n_DU_centralized_percentage,'Linewidth',2)
xlabel("t (240 Hours/ 10 Days)")
ylabel("BW used(%)")
xlim([0 240])

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
bar(DU_split_time,'stacked')
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
bar(total_centralization*100/sum(total_centralization),'stacked')
set(gca,'xticklabel',options)
xtickangle(45)
ylabel('Run time of different split options (%)')
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
