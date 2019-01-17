###################################################################
struct initialize_data
   #ac:true, dc:false
   ac::Bool
   #compensation platform(ac) or ac collection(dc)?
   x_plat::Bool
   #OWPP capacity
   mva::Float64
   #capacity factor of opwp equipment
   cap_fact::Float64
   #System frequency
   freq::Float64
   #onshore grid voltage
   kV_pcc::Float64
   #owpp transmission voltage
   kV_oss::Float64
   #OWPP distance from shore to (1st) platform
   km_pcc::Float64
   #distance from 1st to 2nd platform
   km_oss::Float64
   #transmission cable size
   cbl_pcc::Float64
   #2nd cable size for extra platform
   cbl_oss::Float64
   #number of parralle xformers
   num_xfm::Int64
   #power factor
   pf::Float64
end
###################################################################
mutable struct cst_ks
   FC_ac::Float64
   FC_dc::Float64
   dc::Float64
   f_ct::Float64
   p_ct::Float64
   Qc_oss::Float64
   Qc_pcc::Float64
   life::Float64
   T_op::Float64
   E_op::Float64
end
cst_ks()=cst_ks(0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0)
###################################################################
mutable struct plant
   ac::Bool
   x_plat::Bool
   mva::Float64
   mva_pcc::Float64
   mva_oss::Float64
   E_op::Float64
   lifetime::Float64
   freq::Float64
   length::Float64
end
plant()=plant(true,false,300,300,300,56*10^(-6),15.0,50.0,100.0)
plant(x)=plant(true,false,x,x,x,56*10^(-6),15.0,50.0,100.0)
plant(x,y)=plant(x,false,y,y,y,56*10^(-6),15.0,50.0,100.0)
plant(x,y,z)=plant(x,y,z,z,z,56*10^(-6),15.0,50.0,100.0)
###################################################################
mutable struct cbl
   mva::Float64
   length::Float64
   size::Float64
   amp::Float64
   volt::Float64
   ohm::Float64
   farrad::Float64
   cost::Float64
   num::Float64
   fr::Float64
   mttr::Float64
   mc::Float64
end
cbl()=cbl(0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0)
###################################################################
mutable struct xfm
     mva::Float64
     num::Float64
     eta::Float64
     amp::Float64
     volt::Float64
     ohm::Float64
     cost::Float64
     fr::Float64
     mttr::Float64
     mc::Float64
end
xfm()=xfm(0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0)
###################################################
mutable struct eqp
     xfm_pcc::xfm
     cbl_pcc::cbl
     xfm_oss::xfm
     cbl_oss::cbl
     xfm_x_plat::xfm
end
eqp()=eqp(xfm(),cbl(),xfm(),cbl(),xfm())
###################################################
mutable struct wind
     pu::Array{Float64}
     ce::Array{Float64}
     delta::Float64
end
wind()=wind([],[],0.0)
###################################################
mutable struct cost
     oppc::Float64
     opc::Float64
     tlc_pcc::Float64
     tlc_oss::Float64
     qc::Float64
     cbc::Float64
     rlc::Float64
     mc::Float64
     eens::Float64
end
cost()=cost(0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0)
###################################################
mutable struct owpp
   plant::plant
   eqp::eqp
   wind::wind
   cost::cost
   cst_ks::cst_ks
end
owpp()=owpp(plant(),eqp(),wind(),cost(),cst_ks())
###################################################
