function f=fronthaul_traffic(t_IoT,t_URLLC,t_eMBB,BW_th)

if(t_IoT+t_URLLC+t_eMBB < BW_th)
if(MAC_PHY(t_URLLC+t_eMBB+t_IoT)<BW_th)
        f = MAC_PHY(t_URLLC+t_eMBB+t_IoT);

elseif(MAC_PHY(t_URLLC+t_eMBB)+t_IoT<BW_th)
        f = MAC_PHY(t_URLLC+t_eMBB)+t_IoT;

elseif(MAC_PHY(t_URLLC)+t_eMBB+t_IoT<BW_th)
        f = MAC_PHY(t_URLLC)+t_eMBB+t_IoT;
        
elseif(MAC_PHY(t_eMBB+t_IoT)+t_URLLC<BW_th)
        f = MAC_PHY(t_eMBB+t_IoT)+t_URLLC;
        
elseif(MAC_PHY(t_eMBB)+t_URLLC+t_IoT<BW_th)
        f = MAC_PHY(t_eMBB)+t_URLLC+t_IoT;
        
elseif(MAC_PHY(t_IoT)+t_URLLC+t_URLLC<BW_th)
        f = MAC_PHY(t_IoT)+t_URLLC+t_URLLC;
else
    f = t_IoT+t_URLLC+t_eMBB;       
end
 
end
end
 
function y = MAC_PHY(t)
    y = 1.02*t+1.5;
end

% function y = PDCP_RLC(t)
%     y = t;
% end
