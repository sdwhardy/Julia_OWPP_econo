#############################################
function costOWPP(owpp)
    #unpack variables
    plt=owpp.plant
    delta=owpp.wind.delta
    res=owpp.cost.results
    k=owpp.cost.cst_ks
    xfm_pcc=owpp.eqp.xfm_pcc
    xfm_oss=owpp.eqp.xfm_oss
    x_plat=owpp.eqp.xfm_x_plat
    cbl_pcc=owpp.eqp.cbl_pcc
    cbl_oss=owpp.eqp.cbl_oss
    cst_fct=k.T_op*k.E_op*delta

    #Common Calcs
    res.cbc=ACDC_cbc(cbl_pcc)
    res.tlc_oss=ACDC_tlcOSS(xfm_oss.eta,plt,cst_fct)
    res.cm=ACDC_cm(xfm_oss.num,xfm_oss.mc,xfm_oss.fr,xfm_oss.mttr,k.cf)
    res.cm=res.cm+ACDC_cm(cbl_pcc.num,cbl_pcc.mc,cbl_pcc.fr,cbl_pcc.mttr,k.cf)

    #AC transmission, no intermediate platform transmission = grid voltage
    if plt.ac==true && plt.kV_oss==plt.kV_pcc && plt.x_plat==false
        res.oppc=HVAC_oppc(xfm_oss.mva,xfm_oss.num,k)
        res.qc=HVAC_qc(cbl_pcc,plt,k.Qc_oss,k.Qc_pcc)
        res.rlc=HVAC_rlc(cbl_pcc,xfm_oss.eta,plt,cst_fct,0.0)
        res.opc=0.0
        res.tlc_pcc=0.0
    #AC transmission, intermediate platform transmission = grid voltage
    elseif plt.ac==true && plt.kV_oss==plt.kV_pcc && plt.x_plat==true
        res.oppc=HVAC_oppc(xfm_oss.mva,xfm_oss.num,k)
        res.oppc=res.oppc+HVAC_xplat()
        res.qc=HVAC_qc(cbl_oss,plt,k.Qc_oss,k.Qc_oss)
        res.qc=res.qc+HVAC_qc(cbl_pcc,plt,k.Qc_oss,k.Qc_pcc)
        res.cbc=res.cbc+ACDC_cbc(cbl_oss)
        res.rlc=HVAC_rlc(cbl_oss,xfm_oss.eta,plt,cst_fct,0.0)
        res.rlc=res.rlc+HVAC_rlc(cbl_pcc,xfm_oss.eta,plt,cst_fct,res.rlc)
        res.opc=0.0
        res.tlc_pcc=0.0
        res.cm=res.cm+ACDC_cm(cbl_oss.num,cbl_oss.mc,cbl_oss.fr,cbl_oss.mttr,k.cf)
    #AC transmission, no intermediate platform transmission != grid voltage
    elseif plt.ac==true && plt.kV_oss!=plt.kV_pcc && plt.x_plat==false
        res.oppc=HVAC_oppc(xfm_oss.mva,xfm_oss.num,k)
        res.qc=HVAC_qc(cbl_pcc,plt,k.Qc_oss,k.Qc_pcc)
        res.rlc=HVAC_rlc(cbl_pcc,xfm_oss.eta,plt,cst_fct,0.0)
        res.opc=HVAC_opc(xfm_oss.mva,xfm_oss.num)
        res.tlc_pcc=HVAC_tlcPCC(cbl_pcc,xfm_oss.eta,plt,cst_fct)
        res.cm=res.cm+ACDC_cm(xfm_pcc.num,xfm_pcc.mc,xfm_pcc.fr,xfm_pcc.mttr,k.cf)
    #AC transmission, intermediate platform transmission != grid voltage
    elseif plt.ac==true && plt.kV_oss!=plt.kV_pcc && plt.x_plat==true
        res.oppc=HVAC_oppc(xfm_oss.mva,xfm_oss.num,k)
        res.oppc=res.oppc+HVAC_xplat()
        res.qc=HVAC_qc(cbl_oss,plt,k.Qc_oss,k.Qc_oss)
        res.qc=res.qc+HVAC_qc(cbl_pcc,plt,k.Qc_oss,k.Qc_pcc)
        res.cbc=res.cbc+ACDC_cbc(cbl_oss)
        res.rlc=HVAC_rlc(cbl_oss,xfm_oss.eta,plt,cst_fct,0.0)
        res.rlc=res.rlc+HVAC_rlc(cbl_pcc,xfm_oss.eta,plt,cst_fct,res.rlc)
        res.opc=HVAC_opc(xfm_oss.mva,xfm_oss.num)
        #tlc with mp compensation
        res.tlc_pcc=HVAC_tlcPCCx(cbl_pcc,cbl_oss,xfm_oss.eta,plt,cst_fct)
        res.cm=res.cm+ACDC_cm(cbl_oss.num,cbl_oss.mc,cbl_oss.fr,cbl_oss.mttr,k.cf)
        res.cm=res.cm+ACDC_cm(xfm_pcc.num,xfm_pcc.mc,xfm_pcc.fr,xfm_pcc.mttr,k.cf)
    #DC transmission, no intermediate platform
    elseif plt.ac==false && plt.x_plat==false
        res.oppc=HVDC_oppc(xfm_oss.mva,xfm_oss.num,k)
        res.qc=0.0
        res.rlc=HVDC_rlc(cbl_pcc,x_plat.eta,xfm_oss.eta,plt,cst_fct,plt.ac,0.0)
        res.opc=HVDC_opc(xfm_oss.mva,xfm_oss.num)
        res.tlc_pcc=HVDC_tlcPCC(cbl_pcc,xfm_pcc.eta,xfm_oss.eta,plt,cst_fct)
        res.cm=res.cm+ACDC_cm(xfm_pcc.num,xfm_pcc.mc,xfm_pcc.fr,xfm_pcc.mttr,k.cf)
    #DC transmission, AC collection platform
    else owpp.plant.ac==false && owpp.plant.x_plat==true
        res.oppc=HVDC_oppc(xfm_oss.mva,xfm_oss.num,k)
        res.oppc=res.oppc+HVAC_oppc(x_plat.mva,x_plat.num,k)
        res.tlc_oss=res.tlc_oss+ACDC_tlcOSS(x_plat.eta,plt,cst_fct)
        res.qc=0.0

        println(res.cbc)
        res.cbc=res.cbc+ACDC_cbc(cbl_oss)
        println(res.cbc)
        res.rlc=HVDC_rlc(cbl_oss,x_plat.eta,xfm_oss.eta,plt,cst_fct,true,0.0)
        res.rlc=res.rlc+HVDC_rlc(cbl_pcc,x_plat.eta,xfm_oss.eta,plt,cst_fct,plt.ac,res.rlc)
        res.opc=HVDC_opc(xfm_oss.mva,xfm_oss.num)
        #tlc calc with ac collection
        res.tlc_pcc=HVDC_tlcPCCx(cbl_oss,cbl_pcc,xfm_pcc.eta,xfm_oss.eta,x_plat.eta,plt,cst_fct)
        res.cm=res.cm+ACDC_cm(cbl_oss.num,cbl_oss.mc,cbl_oss.fr,cbl_oss.mttr,k.cf)
        res.cm=res.cm+ACDC_cm(xfm_pcc.num,xfm_pcc.mc,xfm_pcc.fr,xfm_pcc.mttr,k.cf)
    end
    plt.mva_pcc=setPCC_mva(plt.mva_oss,res,cst_fct)
    getEENS(owpp)
    return nothing
end
#############################################
function ACDC_cm(num,mc,fr,mttr,cf)
    A=(num*mc)
    B=(1/fr)
    C=(mttr*30.417*24.0)/8760.0
    cm=cf*(A/(B+C))
    return cm
end
#############################################
function setPCC_mva(mva_oss,res,cst_fct)
    mva_pcc=mva_oss-((res.tlc_oss+res.rlc+res.tlc_pcc)/cst_fct)
    return mva_pcc
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
function HVDC_oppc(mva,num,k)
    #OPPC Calculation
    A=(1+k.dc*(num-2))
    oppc=k.FC_dc+A*k.c_ct*num*mva
    return oppc
end
#############################################
function ACDC_tlcOSS(eta,plt,cst_fct)
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
function ACDC_cbc(cbl)
    #CBC Calculation
    cbc=cbl.length*cbl.num*cbl.cost
    return cbc
end
#############################################
function HVAC_rlc(cbl,eta,plt,cst_fct,loss)
    #RLC Calculation
    A=plt.mva_oss*plt.pf*eta-(loss/cst_fct)
    B=plt.kV_oss
    I=A/B
    R=(cbl.length*cbl.ohm)/(cbl.num)
    rlc=I^2*R*cst_fct
    return rlc
end
#############################################
function HVDC_rlc(cbl,eta_x,eta_r,plt,cst_fct,ac,loss)
    #RLC Calculation
    if ac==true
        A=plt.mva_oss*plt.pf*eta_x
    else
        A=(plt.mva_oss*eta_x-(loss/cst_fct))*eta_r
    end
    B=plt.kV_oss
    I=A/B
    R=(cbl.length*cbl.ohm)/(cbl.num)
    rlc=I^2*R*cst_fct*0.5
    return rlc
end
#############################################
function HVAC_opc(mva,num)
    #calculate opc
    opc=0.02621*(mva*num)^0.7513
    return opc
end
#############################################
function HVDC_opc(mva,num)
    #calculate opc
    opc=0.113*(mva*num)
    return opc
end
#############################################
function HVAC_tlcPCC(cbl,eta,plt,cst_fct)
    #PCC tlc calculation
    A=plt.mva_oss*plt.pf*eta
    B=(cbl.volt)
    I=(A/B)
    R=(cbl.ohm*cbl.length)/cbl.num
    D=A-I^2*R
    tlc_pcc=D*(1-eta)*cst_fct
    return tlc_pcc
end
#############################################
function HVAC_tlcPCCx(cbl_pcc,cbl_oss,eta,plt,cst_fct)
    #PCC tlc calculation
    #oss cable
    A_oss=plt.mva_oss*plt.pf*eta
    B_oss=(cbl_oss.volt)
    I_oss=(A_oss/B_oss)
    R_oss=(cbl_oss.ohm*cbl_oss.length)/cbl_oss.num
    mva_mp=A_oss-I_oss^2*R_oss
    #pcc cable
    B_pcc=(cbl_oss.volt)
    I_pcc=(mva_mp/B_pcc)
    R_pcc=(cbl_pcc.ohm*cbl_pcc.length)/cbl_pcc.num
    mva_pcc=(mva_mp-I_pcc^2*R_pcc)
    tlc_pcc=mva_pcc*(1-eta)*cst_fct
    return tlc_pcc
end
#############################################
function HVDC_tlcPCC(cbl,eta_i,eta_r,plt,cst_fct)
    #PCC tlc calculation
    A=plt.mva_oss*eta_r
    B=(cbl.volt)
    I=(A/B)
    R=0.5*(cbl.ohm*cbl.length)/cbl.num
    D=A-I^2*R
    tlc_pcc=D*(1-eta_i)*cst_fct
    return tlc_pcc
end
#############################################
function HVDC_tlcPCCx(cbl_ac,cbl_dc,eta_i,eta_r,eta_x,plt,cst_fct)
    #PCC tlc calculation
    #Ac portion
    A_ac=plt.mva_oss*plt.pf*eta_x
    B_ac=(cbl_ac.volt)
    I_ac=(A_ac/B_ac)
    R_ac=(cbl_ac.ohm*cbl_ac.length)/cbl_ac.num
    mva_c=A_ac-I_ac^2*R_ac
    #Dc portion
    A_dc=mva_c*eta_r
    B_dc=cbl_dc.volt
    I_dc=(A_dc/B_dc)
    R_dc=0.5*(cbl_dc.ohm*cbl_dc.length)/cbl_dc.num
    tlc_pcc=(A_dc-I_dc^2*R_dc)*(1-eta_i)*cst_fct
    return tlc_pcc
end
#############################################
function HVAC_xplat()
    cst=10.0
    return cst
end
#############################################
function cst_ttl(res)
    ttl=res.oppc+res.opc+res.tlc_pcc+res.tlc_oss+res.rlc+res.qc+res.cbc+res.cm+res.eens
    return ttl
end
