include("data/functions_data.jl")
include("eens/functions_eens.jl")
owpp_bools=getOWPP_bools()
owpp_data=getOWPP_data()
equip_data=getEQP_data()
fail_data=getFAIL_data()
wind_data=getWIND_data()
eens=getEENS(owpp_bools, owpp_data, equip_data, fail_data, wind_data)
display(eens)