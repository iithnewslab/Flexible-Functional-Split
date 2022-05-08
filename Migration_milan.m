global RLC_Buffer_CU RLC_Buffer_DU migration_strategy split_option

RLC_Buffer_CU = zeros(2,150);
RLC_Buffer_DU = zeros(2,150);
split_option = 6;
migration_strategy = "soft";
P_tr = [];
run LTE_parameters.m
for tti = 1:6
    P = Packet_generation(1);
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
            if(tti==5 && migration_strategy == "hard")
                split_option = 2; %given some condition split has changed
                pckt_loss_hard_mig = find(~RLC_Buffer_CU(1,:), 1);
                if(isempty(pckt_loss_hard_mig))
                    pckt_loss_hard_mig = 150;
                else
                    pckt_loss_hard_mig = pckt_loss_hard_mig-1;
                end
                RLC_Buffer_CU(1:end) = 0;
                
            elseif(tti==5 && migration_strategy == "soft")
                split_option = 2; %given some condition split has changed
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
            end
    end
end
