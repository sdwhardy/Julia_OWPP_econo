#############################################
#=function costOWPP(owpp)
    plt=owpp.plant
    cst=owpp.cost
    eqp=owpp.eqp
    #AC transmission, no intermediate platform transmission = grid voltage
    if plt.ac==true && plt.kV_oss==plt.kV_pcc && plt.x_plat==false
        HVAC_oss(cst,eqp,plt)
    #AC transmission, intermediate platform transmission = grid voltage
elseif plt.ac==true && plt.kV_oss==plt.kV_pcc && plt.x_plat==true
        #HVAC_xplat(owpp)
    #AC transmission, no intermediate platform transmission != grid voltage
elseif plt.ac==true && plt.kV_oss!=plt.kV_pcc && plt.x_plat==false
        #HVAC_oss(owpp)
        #HVAC_pcc(owpp)
    #AC transmission, intermediate platform transmission != grid voltage
elseif plt.ac==true && plt.kV_oss!=plt.kV_pcc && plt.x_plat==true
        #HVAC_xplat(owpp)
        #HVAC_pcc(owpp)
    #DC transmission, no intermediate platform
elseif plt.ac==false && plt.x_plat==false

    #DC transmission, AC collection platform
    else owpp.plant.ac==false && owpp.plant.x_plat==true

    end
end
#############################################
function HVAC_oss(cst,eqp,plt)
    #OPPC Calculation
    A=k.FC+(1+k.dc*(xfm.num-2))
    B=(k.f_ct+k.p_ct)*xfm.num*plt.mva_oss
    cst.oppc=A*B
    #OSS tlc Calculation
    cst.tlc_oss=plt.mva_oss*k.pf*(1-xfm.eta)
    #QC Calculation
    NL=cbl.length*cbl.num
    Q=p.volt^2*2*pi*p.freq*cbl.farrad*NL
    Q_oss=Q/2
    Q_pcc=Q/2
    cst.qc=Qc_off*Q_oss+Qc_on*Q_pcc
    #CBC Calculation
    cst.cbc=NL*cbl.cost
    #RLC Calculation
    A=plt.mva_oss*k.pf*xfm.eta
    B=cbl.num*plt.volt
    C=cbl.ohm*NL
    cst.rlc=(A/B)^2*C
    return nothing
end
#############################################
function HVAC_pcc(owpp)
    owpp.cost.opc=0.02621*S_t^0.7513
    owpp.cost.tlc_pcc=(S_t*pf*eta_offt-((S_t*pf*eta_offt)/(n_cbl*(V_n)))^2*r_cbl*l_cbl*n_cbl)*(1-eta_ont)*T_op*E_op*delta
    return nothing
end
#############################################
#=function HVAC_xplat(owpp)
    owpp.cost.oppc=FC+(1+dc*(n_t-2))*(f_ct+p_ct)*n_t*S_st
    owpp.cost.tlc_oss=S_t*pf*(1-eta_offt)*T_op*E_op*delta
    Q=(V_n)^2*2*pi*f_n*Cap_cbl*l_cbl*n_cbl
    Q_off=Q/2
    Q_on=Q/2
    owpp.cost.qc=Qc_off*Q_off+Qc_on*Q_on
    owpp.cost.cbc=n_cbl*c_cbl*l_cbl
    owpp.cost.rlc=((S_t*pf*eta_offt)/(n_cbl*(V_n)))^2*r_cbl*l_cbl*n_cbl*T_op*E_op*delta
    return nothing
end=#
#############################################
=#
