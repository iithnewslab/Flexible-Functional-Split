function Qm=mcs_Qm(mcs)
if(mcs<10 || mcs==29)
	Qm=2;
elseif((mcs>=10&&mcs<17) || mcs==30)
	Qm=4;
else
	Qm=6;
end
end


