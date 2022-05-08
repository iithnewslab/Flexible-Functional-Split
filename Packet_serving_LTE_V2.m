function S = Packet_serving_LTE_V2(Buffer)
no_RB = 100;
consume_RB = 0;
% available_RB = [50 50 50 50];
available_RB = 100;
global  packet_size  usedRB packet_served;
global no_UE  sinr_eachUE  interface_association efficent_bit_persymbol;

usedRB = 0; % zeros(1, no_eNB);
% throughput_calc = zeros(8,no_UE);
% total_throughput = zeros(8,no_UE);

packet_served = zeros(2,no_UE);

efficent_bit_persymbol = zeros(1,no_UE);
% sinr_eachUE = ones(1,no_UE)*25;
sinr_eachUE =  SINR_UE(no_UE);

for u = 1:no_UE
    if(sinr_eachUE(u) < 5.2)
        actual_coding_rate = 602 /1024;
        efficent_bit_persymbol(u) = 2*actual_coding_rate;
    elseif(sinr_eachUE(u) < 6.1)
        actual_coding_rate = 378 /1024;
        efficent_bit_persymbol(u) = 4*actual_coding_rate;
    elseif(sinr_eachUE(u) < 7.55)
        actual_coding_rate = 490 /1024;
        efficent_bit_persymbol(u) = 4*actual_coding_rate;
    elseif(sinr_eachUE(u) < 10.85)
        actual_coding_rate = 616 /1024;
        efficent_bit_persymbol(u) = 4*actual_coding_rate;
    elseif(sinr_eachUE(u) < 11.55)
        actual_coding_rate = 466 /1024;
        efficent_bit_persymbol(u) = 6*actual_coding_rate;
    elseif(sinr_eachUE(u) < 12.75)
        actual_coding_rate = 567 /1024;
        efficent_bit_persymbol(u) = 6*actual_coding_rate;
    elseif(sinr_eachUE(u) < 14.55)
        actual_coding_rate = 666 /1024;
        efficent_bit_persymbol(u) = 6*actual_coding_rate;
    elseif(sinr_eachUE(u) < 18.15)
        actual_coding_rate = 772 /1024;
        efficent_bit_persymbol(u) = 6*actual_coding_rate;
    elseif(sinr_eachUE(u) < 19.25)
        actual_coding_rate = 873 /1024;
        efficent_bit_persymbol(u) = 6*actual_coding_rate;
    elseif(sinr_eachUE(u) > 19.25)
        actual_coding_rate = 948 /1024;
        efficent_bit_persymbol(u) = 6*actual_coding_rate;
    end
end

% for u = 1:no_UE
%     for f = 1: 8
%         if(max(asso_lte(:,u)) == 1)
%             interface_association(f,u) = 1; % 1 = LTE Interface 2 = wifi Interface
%         elseif(max(asso_lte(:,u)) == 0 && max(asso_wifi(:,u)) == 1)
%             interface_association(f,u) = 2; % 2 = wifi Interface
%         end
%     end
% end

interface_association = ones(8,no_UE);
% asso_lte = zeros(no_eNB, no_UE);
% 
% for i = 1:no_UE
%     temp = randi(no_eNB);
%     asso_lte(temp,i) = 1;
% end


for b = 1:150
    f = Buffer(1,b);
    u = Buffer(2,b);
        if(f>0)
%             no_packets: total packets that can be served with available_RB
            no_packet = floor(available_RB * 168 * efficent_bit_persymbol(u) / (packet_size(f) * 8)); 
            consume_RB = ceil((min(1 , no_packet) * packet_size(f) * 8) / (168 * efficent_bit_persymbol(u)));
            if(available_RB > consume_RB && consume_RB > 0)
                available_RB = available_RB - consume_RB;
                usedRB = usedRB + consume_RB;
%                 throughput_calc(b,u) = throughput_calc(b,u) + (min(packet(b,u), no_packet) * (packet_size(b)));
%                 total_throughput(b,u) = total_throughput(b,u) + (min(no_packet,packet(b,u)) * (packet_size(b)));
%                 if(b <= 4)
%                     packet_served(b,u) = packet_served(b,u) + min(packet(b,u), no_packet);
%                 end
                Buffer(:,b) = 0;             
            elseif(available_RB < consume_RB && consume_RB > 0)
                % do nothing
            end
        end
end
% front = find(RLC_Buffer_CU(1,:), 1); %first non-zero
% RLC_Buffer_CU(:,1:150-front+1) = RLC_Buffer_CU(:,front:150);
temp_i = find(Buffer(1,:));
Buffer(:,1:length(temp_i)) = Buffer(:,temp_i);
Buffer(:,length(temp_i)+1:end) = 0;

S = Buffer;
end