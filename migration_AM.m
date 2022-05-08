global RLC_Buffer_CU RLC_Buffer_DU migration_strategy split_option total_throughput;

RLC_Buffer_CU = zeros(2,150);
RLC_Buffer_DU = zeros(2,150);
split_option = 6;
migration_strategy = "timex";
buffer_after_mig_CU = [];
buffer_after_mig_DU = [];
throuput_tti = zeros(100,1);
P_tr = [];
pckt_loss_timex = [];
run LTE_parameters.m
for tti = 1:100
    P = Packet_generation(1);
    throuput_tti(tti) = total_throughput;
    P_tr = zeros(2,sum(P,"all")); %Row-1:flow; 2:user
    temp = 1;
    for p = 1:8
        for q = 1:no_UE
            if(P(p,q)==1)
                P_tr(1,temp) = p;
                P_tr(2,temp) = q;
                temp = temp+1;
            end
        end
    end
    
    switch split_option
        
        case 6 %RLC is running at CU
            level = find(~RLC_Buffer_CU(1,:), 1);
            for b = level:min(150,level+sum(P,"all")-1)
                RLC_Buffer_CU(1,b) = P_tr(1,b-level+1);
                RLC_Buffer_CU(2,b) = P_tr(2,b-level+1);
                
            end
            RLC_Buffer_CU = Packet_serving_LTE_V2(RLC_Buffer_CU);
            if(tti==50 && migration_strategy == "hard")
                split_option = 2; %given some condition split has changed
                pckt_loss_hard_mig = find(~RLC_Buffer_CU(1,:), 1);
                migration_instant = tti;
                if(isempty(pckt_loss_hard_mig))
                    pckt_loss_hard_mig = 150;
                else
                    pckt_loss_hard_mig = pckt_loss_hard_mig-1;
                end
                RLC_Buffer_CU(1:end) = 0;
                
            elseif(tti==50 && (migration_strategy == "soft" ||migration_strategy == "timex"))
                split_option = 2; %given some condition split has changed
                migration_instant = tti;
                total_pck_before_mig = find(~RLC_Buffer_CU(1,:), 1)-1;
            end
            
            
        case 2 %RLC is runnig at DU
            if(migration_strategy == "hard")
                level = find(~RLC_Buffer_DU(1,:), 1);
                for b = level:min(150,level+sum(P,"all")-1)
                    RLC_Buffer_DU(1,b) = P_tr(1,b-level+1);
                    RLC_Buffer_DU(2,b) = P_tr(2,b-level+1);
                end
                RLC_Buffer_DU = Packet_serving_LTE_V2(RLC_Buffer_DU);
                
            elseif(migration_strategy == "soft")
                level = find(~RLC_Buffer_DU(1,:), 1);
                for b = level:min(150,level+sum(P,"all")-1)
                    RLC_Buffer_DU(1,b) = P_tr(1,b-level+1);
                    RLC_Buffer_DU(2,b) = P_tr(2,b-level+1);
                end
                if(find(~RLC_Buffer_CU(1,:), 1)~=1)
                    RLC_Buffer_CU = Packet_serving_LTE_V2(RLC_Buffer_CU);
                else
                    RLC_Buffer_DU = Packet_serving_LTE_V2(RLC_Buffer_DU);
                end
            elseif(migration_strategy == "timex")
                level = find(~RLC_Buffer_DU(1,:), 1);
                for b = level:min(150,level+sum(P,"all")-1)
                    RLC_Buffer_DU(1,b) = P_tr(1,b-level+1);
                    RLC_Buffer_DU(2,b) = P_tr(2,b-level+1);
                end
                if(find(~RLC_Buffer_CU(1,:), 1)~=1 && tti<= migration_instant+10)
                    RLC_Buffer_CU = Packet_serving_LTE_V2(RLC_Buffer_CU);
                    pckt_loss_timex = [pckt_loss_timex,find(~RLC_Buffer_CU(1,:), 1)-1];
                    stored = level-1;
%                 buffer_after_mig_CU = [buffer_after_mig_CU,find(~RLC_Buffer_CU(1,:), 1)-1];
%                 buffer_after_mig_DU = [buffer_after_mig_DU, find(~RLC_Buffer_DU(1,:), 1)-1];
                else
                    RLC_Buffer_DU = Packet_serving_LTE_V2(RLC_Buffer_DU);
                end
%                 buffer_after_mig_CU = [buffer_after_mig_CU,find(~RLC_Buffer_CU(1,:), 1)-1];
%                 buffer_after_mig_DU = [buffer_after_mig_DU, find(~RLC_Buffer_DU(1,:), 1)-1];
            end
    end
    buffer_after_mig_CU = [buffer_after_mig_CU,find(~RLC_Buffer_CU(1,:), 1)-1];
    buffer_after_mig_DU = [buffer_after_mig_DU, find(~RLC_Buffer_DU(1,:), 1)-1];
end
%% Packet loss
% loss = []
loss = 100*pckt_loss_timex/total_pck_before_mig
loss = [100,loss];
tti_after = [0:length(loss)-1];
figure
scatter(tti_after,loss, 'filled', "square")
hold on
scatter(tti_after(1),loss(1),'r','filled', "square")
scatter(tti_after(end),loss(end),'green','filled', "square")
xlabel({'tti_{seconds}','(After Dynamic-split chnage)'})
ylabel('Packet loss(%)')
xlim([0,length(tti_after)])
legend('timex','hard','soft')
grid on
hold off

%% Buffer content variation
% buffer_after_mig_CU = [total_pck_before_mig, buffer_after_mig_CU];
% buffer_after_mig_DU = [0,buffer_after_mig_DU];
figure
stairs(1:60,buffer_after_mig_CU(21:80),'linewidth',2)
hold on
stairs(1:60,buffer_after_mig_DU(21:80),'linewidth',2)
legend('RLC DU','RLC CU')
xlabel('tti')
ylabel({'Buffer Content','(no. of PDUs stored)'})
% xlim([21 80])

%% Case 2: CU to DU
BW_req_handover = buffer_after_mig_CU(50)*1500*8/1e3;


