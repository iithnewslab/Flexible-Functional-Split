% MB = 1024; %1MB = 1024 Bytes
% Traffic = 1500*MB; %Bytes/s (=5MBps)


IP = 1500; %IP packet size in Bytes
PDCP_Hdr = 32;

RLC_Buffer_CU = [ones(145,1); 0; 0; 0; 0; 0]; %ones(150,1);
RLC_Buffer_DU = ones(150,1);

% Pck_tti = (Traffic/IP)/1000;
pck_loss = 0;

for tti = 1:1e5
    incoming_pck = poissrnd(1);
    PDCP_trf = incoming_pck*IP;
    RLC_trf = incoming_pck*(IP+PDCP_Hdr);
    
    rear = find(~RLC_Buffer_CU, 1);
    if (incoming_pck>0)
        if(isempty(rear))
            pck_loss = pck_loss+incoming_pck;
        elseif(incoming_pck>(150-rear+1))
            pck_loss = pck_loss + (incoming_pck-(150-rear));
            RLC_Buffer_CU(rear:end) = 1;
        elseif(rear+incoming_pck<=150)
            RLC_Buffer_CU(rear:rear+incoming_pck) = 1;
%         else
%             RLC_Buffer_CU(rear:end) = 1;      
        end
    end
    
    
    %Debug
    if(length(RLC_Buffer_CU)>150)
        disp('break1')
        break
    end
    
    pop_buffer = poissrnd(2);
    
    front = find(~RLC_Buffer_CU, 1);
    if(pop_buffer>0)
        if(isempty(front))
    %         disp('Buffer is Full')
            RLC_Buffer_CU(end-pop_buffer+1:end) = 0;     
        elseif(front<pop_buffer)
            RLC_Buffer_CU(1:front) = 0;
        elseif(front>pop_buffer)
            RLC_Buffer_CU(front-pop_buffer+1:front) = 0;
        end
    end
    
    %Debug
    if(length(A)>150)
        disp('break2')
        break
    end
   
end