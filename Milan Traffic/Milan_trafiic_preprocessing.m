%% Data Import
format long
sq_id = 1853;
k = 1;
days = 6;
% total_traffic = [];
total_traffic = zeros(days*144,1);

for i=1:days
    fname = sprintf('mi_2013_11_0%d.csv', i);
    data = importdata(fname);
    first = find(data(:,1)==sq_id,1);
    last = find(data(:,1)==sq_id+1,1);
    last = last-1;
    t = data(first:last,2);
    code = data(first:last,3);
    traffic = data(first:last,8);
%     traffic_processed = zeros(144,2); %144 = no. of 10 min in a day
    
    for j = 1:length(t)
        if(code(j)==39)
%             traffic_processed(k,1) = t(j);
%             traffic_processed(k,2) = traffic(j);
            total_traffic(k) = traffic(j);
            k = k+1;
        end
    end
end   

csvwrite('traffic_processed.csv',total_traffic)   

    

% data = csvread('mi_2013_11_02.csv');
% data = importdata('mi_2013_11_02.csv');
% t = csvread('mi_2013_11_02.csv',385900,2,[385900,2,386228,2]);
% t = data(first:last,2);
% code = csvread('mi_2013_11_02.csv',385900,3,[385900,3,386228,3]);
% code = data(385900:386228,3);
% traffic  = csvread('mi_2013_11_02.csv',385900,8,[385900,8,386228,8]);
% traffic = data(385900:386228,8);

%% Data Preprocessing

% traffic_processed = zeros(144,2); %144 = no. of 10 min in a day
% j = 1;
% for i = 1:length(t)
%     if(code(i)==39)
%         traffic_processed(j,1) = t(i);
%         traffic_processed(j,2) = traffic(i);
%         j = j+1;
%     end
% end
%allocated_RBs = csvread('sunday_part.csv',1,5,[1,5,10000,5]);

%% Data Visualization
% plot(traffic_processed(:,1),traffic_processed(:,2));


