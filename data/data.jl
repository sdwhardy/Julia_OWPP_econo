#################################################################
function basic_data()
    #ac:true, dc:false
    acdc=true
    #compensation platform(ac) or ac collection(dc)?
    x_plat=false
    #OWPP capacity
    mva=300.0
    #capacity factor of opwp equipment
    cap_fact=0.72
    #System frequency
    freq=50.0
    #onshore grid voltage
    kV_pcc=220.0
    #owpp transmission voltage
    kV_oss=220.0
    #OWPP distance from shore to (1st) platform
    km_pcc=50.0
    #Distance from 1st to 2nd platform
    km_oss=0.0
    #transmission cable size
    cbl_pcc=1000.0
    #2nd cable size for extra platform
    cbl_oss=0.0
    #number of parralle xformers
    num_xfm=2
    #Energy price
    E_op=56*10^(-6)
    #OWPP lifetime
    life=15
    #initialize
    dataIn=initialize_data(acdc,x_plat,mva,cap_fact,freq,kV_pcc,kV_oss,km_pcc,km_oss,cbl_pcc,cbl_oss,num_xfm,E_op,life)
   return dataIn
end
#################################################################
function cblOPT()
    #Possible cables
    #%kV,cm^2,mohms/km,nF/km,Amps,10^3 pounds/km
    cb0=[220,500,48.9,136,732,815]
    cb1=[220,630,39.1,151,808,850]
    cb2=[220,800,31.9,163,879,975]
    cb3=[220,1000,27.0,177,942,1000]
    cb4=[400,800,31.4,130,870,1400]
    cb5=[400,1000,26.5,140,932,1550]
    cb6=[400,1200,22.1,170,986,1700]
    cb7=[400,1400,18.9,180,1015,1850]
    cb8=[400,1600,16.6,190,1036,2000]
    cb9=[400,2000,13.2,200,1078,2150]
    return [cb0,cb1,cb2,cb3,cb4,cb5,cb6,cb7,cb8,cb9]
end
#################################################################
