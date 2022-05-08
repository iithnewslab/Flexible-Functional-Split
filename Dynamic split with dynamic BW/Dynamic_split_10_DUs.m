% format long
n_DU = 10;
BW_max = 4200*n_DU; %Gbps
duration = 1e2;
BW_used = zeros(duration,1);
n_DU_centralized = zeros(duration,1);
t = linspace(0,1,duration);
run Traffic_10_DU.m
data_Rate = [data_Rate_1;data_Rate_2;data_Rate_3;data_Rate_4;data_Rate_5;data_Rate_6;data_Rate_7;data_Rate_8;data_Rate_9;data_Rate_10];

w0 = [133, 5640 3760, 1880];
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
        if UT(u) > 2400
            ub(u)=1;
            ub(u+n_DU) = 133;
            lb(u)=1;
            lb(u+n_DU) = 133;
            
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
xlabel("t")
% ylim([0 100])
ylabel("BW used(%)")
legend("Dynamic Split", "Fixed split (Option-6)", "Fixed split (Option-2)")
hold off

figure
plot(t,n_DU_centralized_percentage,'Linewidth',2)
xlabel("t")
ylabel("BW used(%)")


