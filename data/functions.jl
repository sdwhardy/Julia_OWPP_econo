##############################################
function newFarm(dataIn)
    #Default OWPP
    myOWPP=owpp()
    #Set plant variables
    getPLANT_data(myOWPP.plant, dataIn)
    #Set equipment
    #Set CableS
    if dataIn.x_plat==false
        myOWPP.eqp.cbl_pcc=getCBL_data(dataIn.kV_pcc,dataIn.cbl_pcc,dataIn.km_pcc,dataIn.mva,dataIn.cap_fact,dataIn.freq)
    else
        myOWPP.eqp.cbl_pcc=getCBL_data(dataIn.kV_pcc,dataIn.cbl_oss,dataIn.km_pcc,dataIn.mva,dataIn.cap_fact,dataIn.freq)
        myOWPP.eqp.cbl_oss=getCBL_data(dataIn.kV_oss,dataIn.cbl_pcc,dataIn.km_oss,dataIn.mva,dataIn.cap_fact,dataIn.freq)
    end


    #getEQP_data(myOWPP.eqp,myOWPP.plant)
    #getEQP_data(myOWPP)
    #push!(myOWPP.wind.pu,111.0)
    #println(myOWPP.wind.pu[1])
    return myOWPP
end
########################################################
function getCBL_data(kV,size,km,mva,cap_fact,freq)
    cbl_data=cbl()
    #kV,cm^2,mohms/km,nF/km,Amps,10^3 pounds/km
    cb=cblOPT()
    i=1
    for i=1:length(cb)
        if kV==cb[i][1] && size==cb[i][2]
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
    #Set failure data
    getCBL_fail(cbl_data)
    #scale for return
    cbl_data.ohm=cbl_data.ohm*10^-3
    cbl_data.farrad=cbl_data.farrad*10^-9
    cbl_data.cost=cbl_data.cost*10^-3
    return cbl_data
end
################################################
function getCBL_mva(l,v,a,q,f)
    mva=(sqrt(3)*v*10^3*a/10^6)^2-((0.5*((v*10^3)^2*2*pi*f*l*q*10^-9))/10^6)^2
    if mva>=0
        mva=sqrt(mva)
    else
        mva=0
    end
 return mva
end
################################################
function getCBL_fail(cbl)
    #failure data
    #cables
    cbl.fr=0.08#/yr/100km
    cbl.mttr=2.0#/yr/100km
    cbl.mc=0.56
    return nothing
end
########################################################
function getPCC_fail(xfm)
    #failure data
    #Onshore transformers
    xfm.fr=0.03#/yr
    xfm.mttr=2.0#month
    xfm.mc=2.8
    return nothing
end
########################################################
function getOSS_fail(xfm)
    #failure data
    #Converters
    xfm.fr=0.56#/yr
    xfm.mttr=1#month
    xfm.mc=2.8#
    return nothing
end
########################################################
function getCONV_fail(xfm)
    #failure data
    #Converters
    conv.fr=0.56#/yr
    conv.mttr=1#month
    conv.mc=2.8#
    return nothing
end
########################################################
function getPLANT_data(plant,data)
    #ac or dc transmission?
    plant.ac=data.acdc
    #compensation plat(ac)/ac collection(dc)?
    x_plat=data.x_plat
    #Size (MW)
    plant.mw=data.mva
    #Cost of energy
    plant.E_op=data.E_op
    #plant lifetime
    plant.lifetime=data.life
    #electrical frequency
    plant.freq=data.freq
    return nothing
end
#=function test()
    b=a+1
    display(b)
end

########################################################
function getEQP_data(eqp,plant)
    if plant.ac==true
        if plant.x_plat==false
            getCBL_data(eqp.cbl_pcc, plant.length, plant)
            getXFM_data(eqp.xfm_oss)
        else
            getCBL_data(eqp.cbl_pcc)
            getXFM_data(eqp.xfm_pcc)
            getCBL_data(eqp.cbl_oss)
            getXFM_data(eqp.xfm_oss)
    else
        if plant.x_plat==true
        else
    #cables
    #PCC to MP/OSS(if no MPC)
    myOWPP.eqp.cbl_pcc.length=50.0
    myOWPP.eqp.cbl_pcc.num=1.0
    myOWPP.eqp.cbl_pcc.cap=216.0
    #MP to OSS(0 if no MPC)
    l_cbl2=0.0
    n_cbl2=0.0
    S_cbl2=0.0
    #PCC xformers/Converters
    S_xfm1=0.0
    n_xfm1=0.0
    #OSS xformers/Converters
    S_xfm2=150.0
    n_xfm2=2.0
    return equip_data=[S_xfm1,n_xfm1,S_xfm2,n_xfm2,l_cbl1,n_cbl1,S_cbl1,l_cbl2,n_cbl2,S_cbl2]
end
########################################################
function getWIND_data()
    pu=[0.002815
0.013872
0.030803
0.041818
0.051038
0.059624
0.06821
0.077746
0.084008
0.089953
0.095475
0.10332
0.11075
0.11743
0.12348
0.13207
0.13928
0.14723
0.15402
0.16092
0.16834
0.1783
0.18699
0.19367
0.20332
0.21106
0.21859
0.2277
0.23713
0.24751
0.25842
0.26859
0.28014
0.29337
0.3065
0.31973
0.33117
0.3425
0.35532
0.36601
0.37798
0.3909
0.4016
0.41398
0.42711
0.43982
0.45443
0.46893
0.48375
0.4993
0.51391
0.53084
0.5483
0.56302
0.57857
0.5936
0.60948
0.62472
0.64007
0.6552
0.67034
0.68442
0.69966
0.71363
0.72866
0.74623
0.76559
0.78842
0.80896
0.83022
0.85405
0.87633
0.89506
0.91072
0.92621
0.94862
0.97833
1]

ce=[3462.7
3366
3219.8
3126.2
3049
2978
2907.8
2831.1
2781.5
2734.9
2692.1
2632.2
2576.5
2527.1
2483
2421.7
2371.2
2316.4
2270.6
2224.7
2176.3
2112.5
2058.1
2017
1958.8
1913
1869.2
1817.1
1764.2
1707.3
1648.8
1595.4
1536.3
1470.1
1406.3
1343.6
1290.9
1239.9
1183.7
1138
1088
1035.5
993.12
945.31
896.11
849.88
798.53
749.31
700.85
651.94
607.81
558.86
510.76
472.16
433.2
397.39
361.46
328.83
297.76
268.87
241.68
217.9
193.72
172.94
152.05
129.64
107.31
84.056
65.769
49.415
34.027
22.407
14.71
9.3906
4.9079
1.3823
0.02014
0]
return [pu ce]
end
#######################################################
=#
