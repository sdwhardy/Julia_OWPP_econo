#############################################
function costOWPP(owpp)
    #unpack variables
    plt=owpp.plant
    delta=owpp.wind.delta
    res=owpp.cost.results
    k=owpp.cost.cst_ks
    xfm_pcc=owpp.eqp.xfm_oss
    xfm_oss=owpp.eqp.xfm_oss
    cbl_pcc=owpp.eqp.cbl_pcc
    cbl_oss=owpp.eqp.cbl_pcc
    cst_fct=k.T_op*k.E_op*delta
    #AC transmission, no intermediate platform transmission = grid voltage
    if plt.ac==true && plt.kV_oss==plt.kV_pcc && plt.x_plat==false
        res.oppc=HVAC_oppc(xfm_oss.mva,xfm_oss.num,k)
        res.tlc_oss=HVAC_tlcOSS(xfm_oss.eta,plt,cst_fct)
        res.qc=HVAC_qc(cbl_pcc,plt,k.Qc_oss,k.Qc_pcc)
        res.cbc=HVAC_cbc(cbl_pcc)
        res.rlc=HVAC_rlc(cbl_pcc,xfm_oss.eta,plt,cst_fct)
        res.opc=0.0
        res.tlc_pcc=0.0
    #AC transmission, intermediate platform transmission = grid voltage
    elseif plt.ac==true && plt.kV_oss==plt.kV_pcc && plt.x_plat==true
        res.oppc=HVAC_oppc(xfm_oss.mva,xfm_oss.num,k)
        res.oppc=res.oppc+HVAC_xplat()
        res.tlc_oss=HVAC_tlcOSS(xfm_oss.eta,plt,cst_fct)
        res.qc=HVAC_qc(cbl_oss,plt,k.Qc_oss,k.Qc_oss)
        res.qc=res.qc+HVAC_qc(cbl_pcc,plt,k.Qc_oss,k.Qc_pcc)
        res.cbc=HVAC_cbc(cbl_pcc)
        res.cbc=res.cbc+HVAC_cbc(cbl_oss)
        res.rlc=HVAC_rlc(cbl_pcc,xfm_oss.eta,plt,cst_fct)
        res.rlc=res.rlc+HVAC_rlc(cbl_oss,xfm_oss.eta,plt,cst_fct)
        res.opc=0.0
        res.tlc_pcc=0.0
    #AC transmission, no intermediate platform transmission != grid voltage
    elseif plt.ac==true && plt.kV_oss!=plt.kV_pcc && plt.x_plat==false
        res.oppc=HVAC_oppc(xfm_oss.mva,xfm_oss.num,k)
        res.tlc_oss=HVAC_tlcOSS(xfm_oss.eta,plt,cst_fct)
        res.qc=HVAC_qc(cbl_pcc,plt,k.Qc_oss,k.Qc_pcc)
        res.cbc=HVAC_cbc(cbl_pcc)
        res.rlc=HVAC_rlc(cbl_pcc,xfm_oss.eta,plt,cst_fct)
        res.opc=HVAC_opc(xfm_oss.mva,xfm_oss.num)
        res.tlc_pcc=HVAC_tlcPCC(cbl_pcc,xfm_oss.eta,plt,cst_fct)
    #AC transmission, intermediate platform transmission != grid voltage
    elseif plt.ac==true && plt.kV_oss!=plt.kV_pcc && plt.x_plat==true
        res.oppc=HVAC_oppc(xfm_oss.mva,xfm_oss.num,k)
        res.oppc=res.oppc+HVAC_xplat()
        res.tlc_oss=HVAC_tlcOSS(xfm_oss.eta,plt,cst_fct)
        res.qc=HVAC_qc(cbl_oss,plt,k.Qc_oss,k.Qc_oss)
        res.qc=res.qc+HVAC_qc(cbl_pcc,plt,k.Qc_oss,k.Qc_pcc)
        res.cbc=HVAC_cbc(cbl_pcc)
        res.cbc=res.cbc+HVAC_cbc(cbl_oss)
        res.rlc=HVAC_rlc(cbl_pcc,xfm_oss.eta,plt,cst_fct)
        res.rlc=res.rlc+HVAC_rlc(cbl_oss,xfm_oss.eta,plt,cst_fct)
        res.opc=HVAC_opc(xfm_oss.mva,xfm_oss.num)
        res.tlc_pcc=HVAC_tlcPCC(cbl_pcc,xfm_oss.eta,plt,cst_fct)
        res.tlc_pcc=res.tlc_pcc+HVAC_tlcPCC(cbl_pcc,xfm_oss.eta,plt,cst_fct)
        res.tlc_pcc=res.tlc_pcc-(plt.mva_oss*plt.pf*xfm_oss.eta*cst_fct*(1-xfm_oss.eta))
    #DC transmission, no intermediate platform
    elseif plt.ac==false && plt.x_plat==false

    #DC transmission, AC collection platform
    else owpp.plant.ac==false && owpp.plant.x_plat==true

    end
    getEENS(owpp)
    return nothing
end
#############################################
function HVAC_oppc(mva,num,k)
    #OPPC Calculation
    A=(1+k.dc*(num-2))
    B=(k.f_ct+k.p_ct)
    oppc=k.FC_ac+A*B*num*mva
    return oppc
end
#############################################
function HVAC_tlcOSS(eta,plt,cst_fct)
    #OSS tlc Calculation
    tlc_oss=plt.mva_oss*plt.pf*(1-eta)*cst_fct
    return tlc_oss
end
#############################################
function HVAC_qc(cbl,plt,Qc_oss,Qc_pcc)
    div=0.5
    #QC Calculation
    A=cbl.farrad*cbl.length*cbl.num
    Q=2*pi*plt.freq*plt.kV_oss^2*A
    Q_oss=Q*div
    Q_pcc=Q*(1-div)
    qc=Qc_oss*Q_oss+Qc_pcc*Q_pcc
    return qc
end
#############################################
function HVAC_cbc(cbl)
    #CBC Calculation
    cbc=cbl.length*cbl.num*cbl.cost
    return cbc
end
#############################################
function HVAC_rlc(cbl,eta,plt,cst_fct)
    #RLC Calculation
    A=plt.mva_oss*plt.pf*eta
    B=plt.kV_oss
    I=A/B
    R=(cbl.length*cbl.ohm)/(cbl.num)
    rlc=I^2*R*cst_fct
    return rlc
end
#############################################
function HVAC_opc(mva,num)
    #calculate opc
    opc=0.02621*(mva*num)^0.7513
    return opc
end
#############################################
function HVAC_tlcPCC(cbl,eta,plt,cst_fct)
    #PCC tlc calculation
    A=plt.mva_oss*plt.pf*eta
    B=(cbl.num*(cbl.volt))
    C=cbl.ohm*cbl.length*cbl.num
    D=A-(A/B)^2*C
    tlc_pcc=D*(1-eta)*cst_fct
    return tlc_pcc
end
#############################################
function HVAC_xplat()
    cst=10.0
    return cst
end
#############################################
