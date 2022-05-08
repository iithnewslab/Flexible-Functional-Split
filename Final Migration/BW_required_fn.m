function B = BW_required_fn(IP_DL_TTI, option, sub_option)


%% System Parameters
Hdr_PDCP =  2; %PDCP header (for RLC AM) in bytes
Hdr_RLC = 5; %RLC AM header in bytes (estimate per IP packet)
Hdr_MAC = 2; %  MAC header in bytes (estimate per IP packet)
IP_pkt = 1500; %IP packet size in Bytes
TBS_DL = 75376; %Transport block size (in bits) for downlink
% IP_DL_TTI = ceil(TBS_DL/((IP_pkt+Hdr_PDCP+Hdr_RLC+Hdr_MAC)*8)); %DL IP packets per Transport block.
TBS_UL = 48936; %Transport block size (in bits) for uplink
IP_UL_TTI = ceil(TBS_UL/((IP_pkt+Hdr_PDCP+Hdr_RLC+Hdr_MAC)*8)); %UL IP packets per Transport block.
N_TBS_DL = 2; %DL number TBS per TTI
N_TBS_UL = 1; %UL number TBS per TTI
Sched = 0.5; %Scheduler overhead per UE in Mbps
FAPI_DL = 1.5; %DL FAPI overhead per UE in Mbps
FAPI_UL = 1; %DL FAPI overhead per UE in Mbps

N_RB = 100; %Number of resource blocks per user
N_SYM_SUB = 14; %Number of symbols per sub-frame
N_SC_RB = 12; %Number of subcarriers per RB
N_SYM_Data = 12; %Number of data carrying symbols per sub-frame
N_UE = 1; %Number of UEs per TTI
N_Ant = 1; %Number of antennas
CFI = 1; %CFI symbols
Qm_PDSCH = 6; %64 QAM modulation used for PDSCH
Qm_PUSCH = 4; %16 QAM modulation used for PUSCH
Qm_PCFICH = 2; %QPSK modulation used for PCFICH
Qm_PDCCH = 2; %QPSK modulation used for PDCCH
Layers_DL = 2; %Number of DL layers
RefSym_REs = 6; %Number of REs for reference signals per RB per sub-frame (for 1 or 2 DL antennas)
PDSCH_REs = N_RB*(N_SC_RB*(N_SYM_SUB-CFI)-(RefSym_REs*N_Ant)); %PDSCH Resource Element per UE
PCFICH_REs = 16; %Number of REs for PCFICH
PHICH_RBEs = 12; %One PHICH group
PDCCH_REs = 144; %Aggregation level 4
N_IQ = 32; %16I + 16Q bits (16 bits is more practical to pass round than 15 bits)
PUCCH_RBs = 2; %Number of RBs allocated for PUCCH
N_LLR = 8; %8-bit LLRs
N_SICiter = 1; %No SIC
N_CPRI = 32; %15I + 15Q bits (CPRI adds 1 control bit per word)
f_s = 30.72; %Mbps, Sampling Rate at 20MHz


%1 user per TTI with 150Mbps DL and 50Mbps UL
User_DL = 150;
User_UL = 50;
%% BW Calculations
switch option
    case 1
        B = (IP_DL_TTI*IP_pkt*N_TBS_DL*8*1000)/1e6;
    case 2
        B = (IP_DL_TTI*(IP_pkt+Hdr_PDCP)*N_TBS_DL*8*1000)/1e6;
    case 4
        B = (IP_DL_TTI*(IP_pkt+Hdr_PDCP+Hdr_RLC)*N_TBS_DL*8*1000)/1e6;
    case 5
        B = ((IP_DL_TTI*(IP_pkt+Hdr_PDCP+Hdr_RLC+Hdr_MAC)*N_TBS_DL*8*1000)/1e6) + Sched;
    case 6
        B = ((IP_DL_TTI*(IP_pkt+Hdr_PDCP+Hdr_RLC+Hdr_MAC)*N_TBS_DL*8*1000)/1e6) + FAPI_DL;
    case 7
        switch sub_option
            case 1
                B = (N_UE*PDSCH_REs*Qm_PDSCH*Layers_DL+(PCFICH_REs*Qm_PCFICH)+(PHICH_RBEs+PDCCH_REs*Qm_PDCCH))*1000/1e6;
            case 2
                B = (N_UE*PDSCH_REs+PCFICH_REs+PHICH_RBEs+PDCCH_REs)*N_IQ*N_Ant*1000/1e6;
            case 3
                B = f_s*N_Ant*N_IQ;
            case 32
                B = f_s*N_Ant*N_IQ;
            case 4
                B = f_s*N_Ant*N_CPRI*(10/8);
        end
    otherwise
        disp("Not a valid input")
end

end