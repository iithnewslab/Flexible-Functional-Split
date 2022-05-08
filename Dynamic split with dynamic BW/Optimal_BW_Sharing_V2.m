% format long
n_DU = 4;
BW_max = 4200*n_DU; %Gbps
duration = 1e2;
t = linspace(0,1,duration);
data_Rate = ones(n_DU,1)*(600 + 3000*sinc(3*t + 1.6))*4;
%%%temp
data_Rate(1,1) = 2400;
data_Rate(2,1) = 2300;
data_Rate(3,1) = 2200;
data_Rate(4,1) = 2100;
% data_Rate(5,1) = 2500;

%%%
w0 = [133, 5640 3760, 1880];
Aeq = zeros(n_DU, 2*n_DU); % Cosntraints % zeros(2*n_DU,1);
beq = zeros(n_DU,1);
A = zeros(2*n_DU,1);
% A = [UT; ones(n_DU,1)];
% A = reshape(A,[1,2*n_DU]);
b = BW_max;
%%
for tti = 1:1
    
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
    BW_used = sum(UT.*x(1:n_DU),"all") + sum(x(n_DU+1:end),"all")
end