include("data/data.jl")
include("data/structure.jl")
include("data/functions.jl")
include("cost/functions_cost.jl")
include("eens/functions_eens.jl")


function main()
    #OWPP basic data
    dataIn=basic_data()
    #initilaize OWPP
    myOWPP=newFarm(dataIn)
    #getCost(myOWPP)

    #display(myOWPP)
    #EENS calc
    getEENS(myOWPP)
    display(myOWPP.cost.eens)
end
main()

#owpp_bools=getOWPP_bools()
#myOWPP=getOWPP_data()

#=equip_data=getEQP_data()
fail_data=getFAIL_data()
wind_data=getWIND_data()=#









#eens=getEENS(owpp_bools, owpp_data, equip_data, fail_data, wind_data)
#capex=getCAPEX()
#println(capex)
