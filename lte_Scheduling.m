function t = lte_Scheduling()
no_RB = 50;
consume_RB = 0;
available_RB = [50 50 50 50];
global packet packet_size  usedRB packet_served;
global no_UE  sinr_eachUE asso_lte interface_association throughput_calc efficent_bit_persymbol total_throughput;
actual_coding_rate = 0;
efficent_bit_persymbol = 0;    
for i = 1 : no_UE
    if(sinr_eachUE(i) < 5.2)
        actual_coding_rate = 602 /1024;
        efficent_bit_persymbol(i) = 2 * actual_coding_rate;
    elseif(sinr_eachUE(i) < 6.1)
        actual_coding_rate = 378 /1024;
        efficent_bit_persymbol(i) = 4 * actual_coding_rate;
    elseif(sinr_eachUE(i) < 7.55)
        actual_coding_rate = 490 /1024;
        efficent_bit_persymbol(i) = 4 * actual_coding_rate;
    elseif(sinr_eachUE(i) < 10.85)
        actual_coding_rate = 616 /1024;
        efficent_bit_persymbol(i) = 4 * actual_coding_rate;
    elseif(sinr_eachUE(i) < 11.55)
        actual_coding_rate = 466 /1024;
        efficent_bit_persymbol(i) = 6 * actual_coding_rate;
    elseif(sinr_eachUE(i) < 12.75)
        actual_coding_rate = 567 /1024;
        efficent_bit_persymbol(i) = 6 * actual_coding_rate;
    elseif(sinr_eachUE(i) < 14.55)
        actual_coding_rate = 666 /1024;
        efficent_bit_persymbol(i) = 6 * actual_coding_rate;
    elseif(sinr_eachUE(i) < 18.15)
        actual_coding_rate = 772 /1024;
        efficent_bit_persymbol(i) = 6 * actual_coding_rate;
    elseif(sinr_eachUE(i) < 19.25)
        actual_coding_rate = 873 /1024;
        efficent_bit_persymbol(i) = 6 * actual_coding_rate;
    elseif(sinr_eachUE(i) > 19.25)
        actual_coding_rate = 948 /1024;
        efficent_bit_persymbol(i) = 6 * actual_coding_rate;
    end
end
for j = 1 : 8
    for k =1 : no_UE
        if(interface_association(j,k) == 1 && packet(j,k) > 0)
            [M,I] = max(asso_lte(:,k));
            no_packet = floor(available_RB(I) * 168 * efficent_bit_persymbol(k) / ( packet_size(j) * 8));
            consume_RB = ceil((min(packet(j,k), no_packet) * packet_size(j) * 8) / (168 * efficent_bit_persymbol(k)));
            if(available_RB(I) > consume_RB && consume_RB > 0)
                available_RB(I) = available_RB(I) - consume_RB;
                usedRB(I) = usedRB(I) + consume_RB;
                throughput_calc(j,k) = throughput_calc(j,k) + (min(packet(j,k), no_packet) * (packet_size(j)));
                total_throughput(j,k) = total_throughput(j,k) + (min(no_packet,packet(j,k)) * (packet_size(j)));
                if(j <= 4)
                    packet_served(j,k) = packet_served(j,k) + min(packet(j,k), no_packet);
                end
                packet(j,k) = packet(j,k) - (min(packet(j,k), no_packet));
                
                
                
            elseif(available_RB(I) < consume_RB && consume_RB > 0)
%                 fprintf('user ');
                k;
%                 fprintf('flow ');
%                 j;
            end
        end
    end
end
end

%%%------------------------------%%%
%interface_association