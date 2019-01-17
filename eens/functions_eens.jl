###############################################################
function getEENS(owpp)
#make capacity probability table
    cpt_tbl=CPT(owpp)
#extract owpp data
    S_pcc=owpp.plant.mva
    E_op=owpp.plant.E_op
    lifetime=owpp.plant.lifetime
    pu=owpp.wind.pu
#Create eens array
    eens_all=[]
    #eens_alla=[]
    eens=0.0
    #println(length(wind_data[:,1]))
#find curtailment ratio
    for i=1:length(cpt_tbl[:,1])
        ratio_curt=cpt_tbl[i,1]/S_pcc
        #println(ratio_curt)
#find closest wind data to curtail ratio
        diff=pu.-ratio_curt
        i_min=argmin(sqrt.((diff[:]).^2))
        #println(i_min)
        #println(diff[i_min])
        if i_min == length(diff) && diff[i_min]<0
            ce=0
        elseif i_min == 1 && diff[i_min]>0
            ce=owpp.wind.ce[1]
        elseif i_min < length(diff) && diff[i_min]<0
            ce=inter_pole(ratio_curt,pu[i_min],pu[i_min+1],owpp.wind.ce[i_min],owpp.wind.ce[i_min+1])
        elseif i_min > 1 && diff[i_min]>0
            ce=inter_pole(ratio_curt,pu[i_min-1],pu[i_min],owpp.wind.ce[i_min-1],owpp.wind.ce[i_min])
        else
            ce=owpp.wind.ce[i_min]
        end
        push!(eens_all, ce*S_pcc*cpt_tbl[i,2])

    end
    eens=sum(eens_all)*lifetime*E_op
    owpp.cost.eens=eens
    return nothing
end
###############################################################
function inter_pole(true_x,min_x,max_x,min_y,max_y)
    slope=(max_y-min_y)/(max_x-min_x)
    b=min_y-slope*min_x
    true_y=slope*true_x+b
    return true_y
end
###############################################################
function blank_TBL(rows,clms)
    XFM_CBL=zeros(rows,clms)
#create all combinations
    round=1;
    k=1;
    multi=1;
    while round<=clms
      while k<rows
        while k<=(multi*2^(clms-round))
          XFM_CBL[k,round]=1;
          k=k+1;
        end
        multi=multi+2;
        k=k+2^(clms-round);
      end
      round=round+1;
      k=1;
      multi=1;
    end
    return XFM_CBL
end
#######################################################
function CPT(owpp)
#unpack owpp data
    S_owpp=owpp.plant.mva
    ac=owpp.plant.ac
    x_plat=owpp.plant.x_plat
#unpack equipment data
    S_xfm_pcc=owpp.eqp.xfm_pcc.mva
    n_xfm_pcc=owpp.eqp.xfm_pcc.num
    S_xfm_oss=owpp.eqp.xfm_oss.mva
    n_xfm_oss=owpp.eqp.xfm_oss.num
    l_cbl_pcc=owpp.eqp.cbl_pcc.length
    n_cbl_pcc=owpp.eqp.cbl_pcc.num
    S_cbl_pcc=owpp.eqp.cbl_pcc.mva
    l_cbl_oss=owpp.eqp.cbl_oss.length
    n_cbl_oss=owpp.eqp.cbl_oss.num
    S_cbl_oss=owpp.eqp.cbl_oss.mva
#Unpack failure data
    FR_c_pcc=(owpp.eqp.cbl_pcc.fr/100.0)*l_cbl_pcc
    if ac==true && x_plat==true
        FR_c_oss=(owpp.eqp.cbl_oss.fr/100.0)*l_cbl_oss
    elseif ac==false && x_plat==true
        FR_c_oss=(owpp.eqp.cbl_oss.fr/100.0)*5.0
    else
        FR_c_oss=0.0
    end
    MTTR_c=owpp.eqp.cbl_pcc.mttr
    mc_c=owpp.eqp.cbl_pcc.mc
    FR_t_pcc=owpp.eqp.xfm_pcc.fr
    MTTR_t_pcc=owpp.eqp.xfm_pcc.mttr
    mc_t_pcc=owpp.eqp.xfm_pcc.mc
    FR_t_oss=owpp.eqp.xfm_oss.fr
    MTTR_t_oss=owpp.eqp.xfm_oss.mttr
    mc_t_oss=owpp.eqp.xfm_oss.mc
    FR_cv=owpp.eqp.xfm_oss.fr
    MTTR_cv=owpp.eqp.xfm_oss.mttr
    mc_cv=owpp.eqp.xfm_oss.mc
#Calculate Availability of cables and xformers/converters
    A_c_pcc=1.0/(1.0+FR_c_pcc*(MTTR_c*30.0*24.0/8760.0))
    A_c_oss=1.0/(1.0+FR_c_oss*(MTTR_c*30.0*24.0/8760.0))
    A_t_pcc=1.0/(1.0+FR_t_pcc*(MTTR_t_pcc*30.0*24.0/8760.0))
    A_t_oss=1.0/(1.0+FR_t_oss*(MTTR_t_oss*30.0*24.0/8760.0))
    A_cv=1.0/(1.0+FR_cv*(MTTR_cv*30.0*24.0/8760.0))
#Create combinatorial matrix of 0s and 1s
#println(n_xfm_pcc,n_xfm_oss,n_cbl_pcc,n_cbl_oss)
    clms=trunc(Int, n_xfm_pcc+n_xfm_oss+n_cbl_pcc+n_cbl_oss)
    rows=trunc(Int, 2.0^clms)
    XFM_CBL=blank_TBL(rows,clms)
    #display(XFM_CBL)
#Create blank power and availability tables
    PWR_tbl=zeros(Float64,rows,5)
    AVL_tbl=ones(Float64,rows,1)
#Sort availability and power of transmisison type
    if ac==true
#pcc XFMR, no comp plat
        if trunc(Int,n_xfm_pcc)>0 && x_plat==false
#Set equipment location
            L1=n_xfm_pcc
            L2=L1+n_cbl_pcc
            L3=L2+n_xfm_oss
            L4=2.0*L3
            L5=2.0*L4
#Set equipment availability
            A1=A_t_pcc
            A2=A_c_pcc
            A3=A_t_oss
            A4=0.0
            A5=0.0
#Set the power
            P1=S_xfm_pcc
            P2=S_cbl_pcc
            P3=S_xfm_oss
            P4=0.0
            P5=0.0
# pcc XFMR and comp plat
        elseif trunc(Int,n_xfm_pcc)>0 && x_plat==true
#Set equipment location
            L1=n_xfm_pcc
            L2=L1+n_cbl_pcc
            L3=L2+n_cbl_oss
            L4=L3+n_xfm_oss
            L5=2.0*L4
#Set equipment availability
            A1=A_t_pcc
            A2=A_c_pcc
            A3=A_c_oss
            A4=A_t_oss
            A5=0.0
#Set the power
            P1=S_xfm_pcc
            P2=S_cbl_pcc
            P3=S_cbl_oss
            P4=S_xfm_oss
            P5=0.0
#No pcc SS and no comp plat
        elseif trunc(Int,n_xfm_pcc)==0  && x_plat==false
#Set equipment location
            L1=n_cbl_pcc
            L2=L1+n_xfm_oss
            L3=2.0*L2
            L4=2.0*L3
            L5=2.0*L4
#Set equipment availability
            A1=A_c_pcc
            A2=A_t_oss
            A3=0.0
            A4=0.0
            A5=0.0
#Set the power
            P1=S_cbl_pcc
            P2=S_xfm_oss
            P3=0.0
            P4=0.0
            P5=0.0
#AC no pCC XFM with comp plat
        elseif trunc(Int,n_xfm_pcc)==0  && x_plat==true
#Set equipment location
            L1=n_cbl_pcc
            L2=L1+n_cbl_oss
            L3=L2+n_xfm_oss
            L4=2.0*L3
            L5=2.0*L4
#Set equipment availability
            A1=A_c_pcc
            A2=A_c_oss
            A3=A_t_oss
            A4=0.0
            A5=0.0
#Set the power
            P1=S_cbl_pcc
            P2=S_cbl_oss
            P3=S_xfm_oss
            P4=0.0
            P5=0.0
#Notify AC sytem setup error
        else
            error("AC eens sytem setup failure!")
        end
#DC option
    elseif ac==false
#DC option with no AC collection
        if x_plat==false
#Set equipment location
            L1=n_xfm_pcc
            L2=L1+n_cbl_pcc
            L3=L2+n_xfm_oss
            L4=2.0*L3
            L5=2.0*L4
#Set equipment availability
            A1=A_cv
            A2=A_c_pcc
            A3=A_cv
            A4=0.0
            A5=0.0
#Set the power
            P1=S_xfm_pcc
            P2=S_cbl_pcc
            P3=S_xfm_oss
            P4=0.0
            P5=0.0
#DC option with AC OSS collector
        elseif x_plat==true
#Set equipment location
            L1=n_xfm_pcc
            L2=L1+n_cbl_pcc
            L3=L2+n_xfm_oss
            L4=L3+n_cbl_oss
            L5=L4+n_xfm_oss
#Set equipment availability
            A1=A_cv
            A2=A_c_pcc
            A3=A_cv
            A4=A_c_oss
            A5=A_t_oss
#Set the power
            P1=S_xfm_pcc
            P2=S_cbl_pcc
            P3=S_xfm_oss
            P4=S_cbl_oss
            P5=S_xfm_oss
#If neither cheap nor expensive DC an error has occured
        else
            error("DC eens sytem setup failure!")
        end
#If neither AC or DC an error has occured
    else
        error("AC/DC eens sytem error!")
    end
#Set powers and availabilities
    k=1
    j=1
    series=0
    while k<=clms
        while j<=rows
            if k<=trunc(Int,L1)
                #println("L1 match!")
                if trunc(Int,XFM_CBL[j,k])==1
                    AVL_tbl[j]=AVL_tbl[j]*A1
                    PWR_tbl[j,1]=min(S_owpp,PWR_tbl[j,1]+P1)
                else
                    AVL_tbl[j]=AVL_tbl[j]*(1-A1)
                end
                series=1
            elseif k<=trunc(Int,L2)
                #println("L2 match!")
                if trunc(Int,XFM_CBL[j,k])==1
                    AVL_tbl[j]=AVL_tbl[j]*A2
                    PWR_tbl[j,2]=min(S_owpp,PWR_tbl[j,2]+P2)
                else
                    AVL_tbl[j]=AVL_tbl[j]*(1-A2)
                end
                series=2
            elseif k<=trunc(Int,L3)
                #println("L3 match!")
                if trunc(Int,XFM_CBL[j,k])==1
                    AVL_tbl[j]=AVL_tbl[j]*A3
                    PWR_tbl[j,3]=min(S_owpp,PWR_tbl[j,3]+P3)
                else
                    AVL_tbl[j]=AVL_tbl[j]*(1-A3)
                end
                series=3
            elseif k<=trunc(Int,L4)
                #println("L4 match!")
                if trunc(Int,XFM_CBL[j,k])==1
                    AVL_tbl[j]=AVL_tbl[j]*A4
                    PWR_tbl[j,4]=min(S_owpp,PWR_tbl[j,4]+P4)
                else
                    AVL_tbl[j]=AVL_tbl[j]*(1-A4)
                end
                series=4
            elseif k<=trunc(Int,L5)
                #println("L5 match!")
                if trunc(Int,XFM_CBL[j,k])==1
                    AVL_tbl[j]=AVL_tbl[j]*A5
                    PWR_tbl[j,5]=min(S_owpp,PWR_tbl[j,5]+P5)
                else
                    AVL_tbl[j]=AVL_tbl[j]*(1-A5)
                end
                series=5
            else
                println("no match!")
            end
            j=j+1
        #println(j)
      end
      j=1
      k=k+1
  end
pwr_series=zeros(Float64,rows,1)
for i=1:rows
    pwr_series[i]=minimum(PWR_tbl[i,1:series])
end
for i=1:rows
    pwr_series[i]=minimum(PWR_tbl[i,1:series])
end
tbl_c1=unique(pwr_series)
tbl_c2=zeros(Float64,length(tbl_c1),1)
k=1
j=1
while(k<=length(tbl_c1))
  while (j<=length(AVL_tbl))
      if pwr_series[j]==tbl_c1[k]
          tbl_c2[k]=tbl_c2[k]+AVL_tbl[j]
      end
    j=j+1;
  end
  j=1;
  k=k+1;
end
    if sum(tbl_c2) > 1.00001 || sum(tbl_c2) < 0.99999
        error("probability does not sum to 1")
    elseif maximum(tbl_c1) > S_owpp && minimum(tbl_c1) > 1
        error("power is not correct")
    else
      return [tbl_c1 tbl_c2]
    end
end
##########################################################
