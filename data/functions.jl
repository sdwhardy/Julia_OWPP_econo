##############################################
function newFarm(dataIn)
    #Default OWPP
    myOWPP=owpp()
    #Set plant variables
    getPLANT_data(myOWPP.plant, dataIn)
    getCost_ks(myOWPP.cst_ks)
    #Set equipment
    #Set CableS
    if dataIn.x_plat==false
        myOWPP.eqp.cbl_pcc=getCBL_data(dataIn.kV_pcc,dataIn.cbl_pcc,dataIn.km_pcc,dataIn.mva,dataIn.cap_fact,dataIn.freq)
        myOWPP.plant.mva_oss=myOWPP.eqp.cbl_pcc.mva*myOWPP.eqp.cbl_pcc.num
    else
        myOWPP.eqp.cbl_pcc=getCBL_data(dataIn.kV_pcc,dataIn.cbl_oss,dataIn.km_pcc,dataIn.mva,dataIn.cap_fact,dataIn.freq)
        myOWPP.eqp.cbl_oss=getCBL_data(dataIn.kV_oss,dataIn.cbl_pcc,dataIn.km_oss,dataIn.mva,dataIn.cap_fact,dataIn.freq)
        myOWPP.plant.mva_oss=min(myOWPP.eqp.cbl_oss.mva*myOWPP.eqp.cbl_oss.num,myOWPP.eqp.cbl_pcc.mva*myOWPP.eqp.cbl_pcc.num)
    end
    #Set Xfrmers
    #AC transmission, no intermediate platform transmission = grid voltage
    if dataIn.ac==true && dataIn.kV_oss==dataIn.kV_pcc && dataIn.x_plat==false
        myOWPP.eqp.xfm_pcc=getXPCC_data(myOWPP.plant.mva_oss,0,dataIn.kV_oss)
        myOWPP.eqp.xfm_oss=getXOSS_data(myOWPP.plant.mva_oss,dataIn.num_xfm,dataIn.kV_oss)
        myOWPP.eqp.xfm_x_plat=getXPLT_data(myOWPP.plant.mva_oss,0.0,dataIn.kV_oss)
    #AC transmission, intermediate platform transmission = grid voltage
    elseif dataIn.ac==true && dataIn.kV_oss==dataIn.kV_pcc && dataIn.x_plat==true
        myOWPP.eqp.xfm_pcc=getXPCC_data(myOWPP.plant.mva_oss,0.0,dataIn.kV_oss)
        myOWPP.eqp.xfm_oss=getXOSS_data(myOWPP.plant.mva_oss,dataIn.num_xfm,dataIn.kV_oss)
        myOWPP.eqp.x_plat=getXPLT_data(myOWPP.plant.mva_oss,1.0,dataIn.kV_oss)
    #AC transmission, no intermediate platform transmission != grid voltage
    elseif dataIn.ac==true && dataIn.kV_oss!=dataIn.kV_pcc && dataIn.x_plat==false
        myOWPP.eqp.xfm_pcc=getXPCC_data(myOWPP.plant.mva_oss,dataIn.num_xfm,dataIn.kV_oss)
        myOWPP.eqp.xfm_oss=getXOSS_data(myOWPP.plant.mva_oss,dataIn.num_xfm,dataIn.kV_oss)
        myOWPP.eqp.x_plat=getXPLT_data(myOWPP.plant.mva_oss,0.0,dataIn.kV_oss)
    #AC transmission, intermediate platform transmission != grid voltage
    elseif dataIn.ac==true && dataIn.kV_oss!=dataIn.kV_pcc && dataIn.x_plat==true
        myOWPP.eqp.xfm_pcc=getXPCC_data(myOWPP.plant.mva_oss,dataIn.num_xfm,dataIn.kV_oss)
        myOWPP.eqp.xfm_oss=getXOSS_data(myOWPP.plant.mva_oss,dataIn.num_xfm,dataIn.kV_oss)
        myOWPP.eqp.x_plat=getXPLT_data(myOWPP.plant.mva_oss,1.0,dataIn.kV_oss)
    #DC transmission, no intermediate platform
    elseif dataIn.ac==false && dataIn.x_plat==false
        myOWPP.eqp.xfm_pcc=getCPCC_data(myOWPP.plant.mva_oss,dataIn.num_xfm,dataIn.kV_oss)
        myOWPP.eqp.xfm_oss=getCOSS_data(myOWPP.plant.mva_oss,dataIn.num_xfm,dataIn.kV_oss)
        myOWPP.eqp.x_plat=getXPLT_data(myOWPP.plant.mva_oss,0.0,dataIn.kV_oss)
    #DC transmission, AC collection platform
    else dataIn.ac==false && dataIn.x_plat==true
        myOWPP.eqp.xfm_pcc=getCPCC_data(myOWPP.plant.mva_oss,dataIn.num_xfm,dataIn.kV_oss)
        myOWPP.eqp.xfm_oss=getCOSS_data(myOWPP.plant.mva_oss,dataIn.num_xfm,dataIn.kV_oss)
        myOWPP.eqp.x_plat=getXPLT_data(myOWPP.plant.mva_oss,1.0,dataIn.kV_oss)
    end
    getWIND_data(myOWPP.wind)
    return myOWPP
end
########################################################
function getXPCC_data(S,num,kV)
    xfmr=xfm()
    getXFO_basics(xfmr,S,num,kV)
    getPCC_fail(xfmr)
    return xfmr
end
########################################################
function getXOSS_data(S,num,kV)
    xfmr=xfm()
    getXFO_basics(xfmr,S,num,kV)
    getOSS_fail(xfmr)
    xfmr.eta=recEta()
    return xfmr
end
########################################################
function getCPCC_data(S,num,kV)
    xfmr=xfm()
    getXFO_basics(xfmr,S,num,kV)
    getCONV_fail(xfmr)
    xfmr.eta=invEta()
    return xfmr
end
########################################################
function getCOSS_data(S,num,kV)
    xfmr=xfm()
    getXFO_basics(xfmr,S,num,kV)
    getCONV_fail(xfmr)
    xfmr.eta=recEta()
    return xfmr
end
########################################################
function getXPLT_data(S,num,kV)
    xfmr=xfm()
    getXFO_basics(xfmr,S,num,kV)
    getOSS_fail(xfmr)
    xfmr.eta=xfoEta()
    return xfmr
end
########################################################
function getXFO_basics(xfmr,S,num,kV)
    if num==0.0
        xfmr.mva=0.0
    else
        xfmr.mva=S/num
    end
    #############
    #xfmr.mva=150.0
    ###############
    xfmr.num=num
    xfmr.amp=xfmr.mva/(kV*sqrt(3))
    xfmr.volt=kV
    xfmr.ohm=0.0
    xfmr.cost=0.0
    return nothing
end
########################################################
function getCBL_data(kV,size,km,mva,cap_fact,freq)
    cbl_data=cbl()
    #kV,cm^2,mohms/km,nF/km,Amps,10^3 pounds/km
    cb=cblOPT()
    i=1
    for i=1:length(cb)
        if kV==cb[i][1] && size==cb[i][2]
            #fill in cable data
            cbl_data.volt=cb[i][1]
            cbl_data.size=cb[i][2]
            cbl_data.ohm=cb[i][3]
            cbl_data.farrad=cb[i][4]
            cbl_data.amp=cb[i][5]
            cbl_data.cost=cb[i][6]
            cbl_data.length=km
            cbl_data.mva=getCBL_mva(km,cbl_data.volt,cbl_data.amp,cbl_data.farrad,freq)
        else
        end
    end
    #Set number of cables in parallel
    cbl_data.num=ceil((mva*cap_fact)/cbl_data.mva)
#########################
    #cbl_data.num=1
#########################
    #Set failure data
    getCBL_fail(cbl_data)
    #scale for return
    cbl_data.ohm=cbl_data.ohm*10^-3
    cbl_data.farrad=cbl_data.farrad*10^-9
    cbl_data.cost=cbl_data.cost*10^-3
    return cbl_data
end
############################################################
#Calculate the cable capacity at the transmission distance
function getCBL_mva(l,v,a,q,f)
    mva=(sqrt(3)*v*10^3*a/10^6)^2-((0.5*((v*10^3)^2*2*pi*f*l*q*10^-9))/10^6)^2
    if mva>=0
        mva=sqrt(mva)
    else
        mva=0
    end
 return mva
end
########################################################
function getPLANT_data(plant,data)
    #ac or dc transmission?
    plant.ac=data.ac
    #compensation plat(ac)/ac collection(dc)?
    x_plat=data.x_plat
    #Size (MW)
    plant.mva=data.mva
    #electrical frequency
    plant.freq=data.freq
    #distance from shore
    plant.length=data.km_pcc+data.km_oss
    return nothing
end
