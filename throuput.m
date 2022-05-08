mcs = csvread('sunday_part.csv',1,4,[1,4,10000,4]);
allocated_RBs = csvread('sunday_part.csv',1,5,[1,5,10000,5]);

Qm = [];
for i=1:length(mcs)    
Qm(i) = mcs_Qm(mcs(i));
end
length(Qm);

RB = 168000;

data_rate = RB.*(Qm.*allocated_RBs');
t = linspace(0.5*0.001,0.5*10000,10000);
plot(t,data_rate)
