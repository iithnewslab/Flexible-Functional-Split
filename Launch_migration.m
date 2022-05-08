% clearvars;

% Total = zeros(1,100);
% Left = zeros(1,100);
% Served = zeros(1,100);


ABC = zeros(100,3);
run LTE_parameters.m
% iijj = 0;
for iijj = 1:100

P = Packet_generation(1);
Packet_serving_LTE();

    
    % fprintf("Total: %d\n", sum(P,"all"))
    ABC(iijj,1) = sum(P,"all");
    % fprintf("Served: %d\n", sum(packet_served,"all"))
    ABC(iijj,2) = sum(packet_served,"all");
    % fprintf("Left: %d\n", sum(packet,"all"))
    ABC(iijj,3) = sum(packet,"all");
    
end


%count total bytes
total_bytes = 0;
for i = 1:8
    total_bytes = total_bytes + packet_size(i)*sum(P(i,:),"all");
end