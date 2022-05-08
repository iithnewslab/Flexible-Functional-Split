% MB = 1024; %1MB = 1024 Bytes
% Traffic = 1500*MB; %Bytes/s (=5MBps)


IP = 1500; %IP packet size in Bytes
PDCP_Hdr = 32;

RLC_Buffer_CU = [ones(145,1); 0; 0; 0; 0; 0]; %ones(150,1);
RLC_Buffer_DU = zeros(150,1);

% Pck_tti = (Traffic/IP)/1000;
pck_loss = 0;

migration = "hard";

split = 1;

%To debug
inc_aft_mig = 0;
out_aft_mig = 0;


for tti = 1:1e4
    incoming_pck = poissrnd(1);
    
    PDCP_trf = incoming_pck*IP;
    RLC_trf = incoming_pck*(IP+PDCP_Hdr);
    
    pop_buffer = poissrnd(1);
    
    switch split
        case 1
                rear = find(~RLC_Buffer_CU, 1);
                if (incoming_pck>0)
                    if(isempty(rear))
                        pck_loss = pck_loss+incoming_pck;
                    elseif(incoming_pck>(150-rear+1))
                        pck_loss = pck_loss + (incoming_pck-(150-rear));
                        RLC_Buffer_CU(rear:end) = 1;
                    elseif(rear+incoming_pck<=150)
                        RLC_Buffer_CU(rear:rear+incoming_pck-1) = 1;    
                    end
                end
                
                
                front = find(~RLC_Buffer_CU, 1);
                if(pop_buffer>0)
                    if(isempty(front))
                        RLC_Buffer_CU(end-pop_buffer+1:end) = 0;     
                    elseif(front-1<=pop_buffer)
                        RLC_Buffer_CU(1:front) = 0;
                    elseif(front-1>pop_buffer)
                        RLC_Buffer_CU(front-pop_buffer:front) = 0;
                    end
                end
                if(tti==1000)
                    split = 2; %given some condition split has changed
                    pckt_loss_mig = find(~RLC_Buffer_CU, 1);
                    if(isempty(pckt_loss_mig))
                        pckt_loss_mig = 150;
                    else
                        pckt_loss_mig = pckt_loss_mig-1;
                    end
                    pck_loss = pck_loss + pckt_loss_mig;
                    RLC_Buffer_CU(1:end) = 0;
                end      

        case 2
                switch migration
                    case "hard"
                        %hard migration
                        inc_aft_mig = inc_aft_mig + incoming_pck;
                        out_aft_mig = out_aft_mig + pop_buffer;
                        rear = find(~RLC_Buffer_DU, 1);
                        if (incoming_pck>0)
                            if(isempty(rear))
                                pck_loss = pck_loss+incoming_pck;
                            elseif(incoming_pck>(150-rear+1))
                                pck_loss = pck_loss + (incoming_pck-(150-rear));
                                RLC_Buffer_DU(rear:end) = 1;
                            elseif(rear+incoming_pck<=150)
                                RLC_Buffer_DU(rear:rear+incoming_pck-1) = 1;    
                            end
                        end
                        
                        
                        front = find(~RLC_Buffer_DU, 1);
                        if(pop_buffer>0)
                            if(isempty(front))
                                RLC_Buffer_DU(end-pop_buffer+1:end) = 0;     
                            elseif(front-1<=pop_buffer)
                                RLC_Buffer_DU(1:front) = 0;
                            elseif(front-1>pop_buffer)
                                RLC_Buffer_DU(front-pop_buffer:front) = 0;
                            end
                        end
                       
                        
                end
            
    end
    
   
end