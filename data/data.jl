#################################################################
function basic_data()
    #ac:true, dc:false
    acdc=true
    #compensation platform(ac) or ac collection(dc)?
    x_plat=true
    #OWPP capacity
    mva=500.0
    #capacity factor of opwp equipment
    cap_fact=1.0
    #System frequency
    freq=50.0
    #onshore grid voltage
    kV_pcc=400.0
    #owpp transmission voltage
    kV_oss=220.0
    #OWPP distance from shore to (1st) platform
    km_pcc=50.0
    #Distance from 1st to 2nd platform
    km_oss=5.0
    #transmission cable size
    cbl_pcc=1000.0
    #2nd cable size for extra platform
    cbl_oss=800.0
    #number of parralle xformers
    num_xfm=1
    #power factor
    pf=1.0
    #initialize
    dataIn=initialize_data(acdc,x_plat,mva,cap_fact,freq,kV_pcc,kV_oss,km_pcc,km_oss,cbl_pcc,cbl_oss,num_xfm,pf)
   return dataIn
end
#################################################################
function getCost_ks()
    #fixed AC cost
        FC_ac=5.6
    #fixed AC cost
        FC_dc=28.0
    #penalization factor for different than 2 xfrms
        dc=0.2
    #farm variable cost
        f_ct=0.0224
    #platform variable cost
        p_ct=0.028
    #converter variable cost
        c_ct=0.1232
    #Q cost offshore
        Qc_oss=0.028
    #Q cost onshore
        Qc_pcc=0.0168
    #lifetime
        life=15.0
    #Operational lifetime in hours
        T_op=365*24*life
    #Energy price
        E_op=56.0*10^(-6)
    #Capitalization factor
        cf=10
    ks=cst_ks(FC_ac,FC_dc,dc,f_ct,p_ct,c_ct,Qc_oss,Qc_pcc,life,T_op,E_op,cf)
    return ks
end
#################################################################
function cblOPT()
    #Possible cables
    #%kV,cm^2,mohms/km,nF/km,Amps,10^3 euros/km
    #Ac Cables
    p2e=1.0
    cb0=[132.0,630.0,39.5,209,818,685*p2e]
    cb1=[132.0,800.0,32.4,217,888,795*p2e]
    cb2=[132.0,1000.0,27.5,238,949,860*p2e]
    cb3=[220.0,500.0,48.9,136,732,815*p2e]
    cb4=[220.0,630.0,39.1,151,808,850*p2e]
    cb5=[220.0,800.0,31.9,163,879,975*p2e]
    cb6=[220.0,1000.0,27.0,177,942,1000*p2e]
    cb7=[400.0,800.0,31.4,130,870,1400*p2e]
    cb8=[400.0,1000.0,26.5,140,932,1550*p2e]
    cb9=[400.0,1200.0,22.1,170,986,1700*p2e]
    cb10=[400.0,1400.0,18.9,180,1015,1850*p2e]
    cb11=[400.0,1600.0,16.6,190,1036,2000*p2e]
    cb12=[400.0,2000.0,13.2,200,1078,2150*p2e]
    #Dc Cables
    cb13=[150.0,1000.0,22.4,0.0,1644,670*p2e]
    cb14=[150.0,1200.0,19.2,0.0,1791,730*p2e]
    cb15=[150.0,1400.0,16.5,0.0,1962,785*p2e]
    cb16=[150.0,1600.0,14.4,0.0,2123,840*p2e]
    cb17=[150.0,2000.0,11.5,0.0,2407,900*p2e]
    cb18=[300.0,1000.0,22.4,0.0,1644,855*p2e]
    cb19=[300.0,1200.0,19.2,0.0,1791,940*p2e]
    cb20=[300.0,1400.0,16.5,0.0,1962,1015*p2e]
    cb21=[300.0,1600.0,14.4,0.0,2123,1090*p2e]
    cb22=[300.0,2000.0,11.5,0.0,2407,1175*p2e]
    return [cb0,cb1,cb2,cb3,cb4,cb5,cb6,cb7,cb8,cb9,cb10,cb11,cb12,cb13,cb14,cb15,cb16,cb17,cb18,cb19,cb20,cb21,cb22]
end
#################################################################
function getCBL_fail(cbl)
    #failure data
    #cables
    cbl.fr=0.04#/yr/100km
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
    xfm.fr=0.03#/yr
    xfm.mttr=6.0#month
    xfm.mc=2.8#
    return nothing
end
########################################################
function getCONV_fail(conv)
    #failure data
    #Converters
    conv.fr=0.12#/yr
    conv.mttr=1#month
    conv.mc=0.56#
    return nothing
end
########################################################
function xfoEta()
    eta=0.994
    return eta
end
########################################################
function recEta()
    eta=0.9828
    return eta
end
########################################################
function invEta()
    eta=0.9819
    return eta
end
########################################################
function getWIND_data(wind)
wind.delta=0.23
wind.pu=[0.002815
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

wind.ce=[3462.7
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
return nothing
end
#######################################################
