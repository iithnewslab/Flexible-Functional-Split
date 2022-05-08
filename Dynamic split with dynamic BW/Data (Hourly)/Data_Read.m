T1 = readmatrix("DU_1.csv");
T2 = readmatrix("DU_2.csv");
T3 = readmatrix("DU_3.csv");
T4 = readmatrix("DU_4.csv");
T5 = readmatrix("DU_5.csv");
T6 = readmatrix("DU_6.csv");
T7 = readmatrix("DU_7.csv");
T8 = readmatrix("DU_8.csv");
T9 = readmatrix("DU_9.csv");
% T10 = readmatrix("DU_10.csv");
T10 = readmatrix("DU_11.csv");

T1(:,2) = smooth(T1(:,2));
T2(:,2) = smooth(T2(:,2));
T3(:,2) = smooth(T3(:,2));
T4(:,2) = smooth(T4(:,2));
T5(:,2) = smooth(T5(:,2));
T6(:,2) = smooth(T6(:,2));
T7(:,2) = smooth(T7(:,2));
T8(:,2) = smooth(T8(:,2));
T9(:,2) = smooth(T9(:,2));
T10(:,2) = smooth(T10(:,2));

max_all = zeros(10,1);
max_all(1) = max(T1(:,2));
max_all(2) = max(T2(:,2));
max_all(3) = max(T3(:,2));
max_all(4) = max(T4(:,2));
max_all(5) = max(T5(:,2));
max_all(6) = max(T6(:,2));
max_all(7) = max(T7(:,2));
max_all(8) = max(T8(:,2));
max_all(9) = max(T9(:,2));
max_all(10) = max(T10(:,2));

max_traffic = max(max_all);
norm_fact = 4e3/max_traffic;
%% Normalizing
T1(:,2) = (T1(:,2))*4000/max_all(1);
T2(:,2) = (T2(:,2))*4000/max_all(2);
T3(:,2) = (T3(:,2))*4000/max_all(3);
T4(:,2) = (T4(:,2))*4000/max_all(4);
T5(:,2) = (T5(:,2))*4000/max_all(5);
T6(:,2) = (T6(:,2))*4000/max_all(6);
T7(:,2) = (T7(:,2))*4000/max_all(7);
T8(:,2) = (T8(:,2))*4000/max_all(8);
T9(:,2) = (T9(:,2))*4000/max_all(9);
T10(:,2) = (T10(:,2))*4000/max_all(10);

% T1(:,2) = (T1(:,2))*norm_fact;
% T2(:,2) = (T2(:,2))*norm_fact;
% T3(:,2) = (T3(:,2))*norm_fact;
% T4(:,2) = (T4(:,2))*norm_fact;
% T5(:,2) = (T5(:,2))*norm_fact;
% T6(:,2) = (T6(:,2))*norm_fact;
% T7(:,2) = (T7(:,2))*norm_fact;
% T8(:,2) = (T8(:,2))*norm_fact;
% T9(:,2) = (T9(:,2))*norm_fact;
% T10(:,2) = (T10(:,2))*norm_fact;


%% Data plot
duration = 240;
t = linspace(0,239,duration);
% plot(t(1:144), T6(1:144,2));
plot(T6(:,2),"LineWidth",1.5)
hold on
plot(T7(:,2),"LineWidth",1.5)
grid on
% xlabel("t (240 Hours/ 10 Days)")
options = {'Mon','Tue', 'Wed', 'Thu','Fri','Sat', 'Sun'};
set(gca,'xticklabel',options)
xticks(12:24:239)
xtickangle(45)
ylabel("Trafiic")
legend("DU_1", "DU_2")
hold off