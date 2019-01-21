include("data/data.jl")
include("data/structure.jl")
include("data/functions_data.jl")
include("cost/functions_cost.jl")
include("eens/functions_eens.jl")


function main()
    #OWPP basic data
    dataIn=basic_data()
    #initilaize OWPP
    myOWPP=newFarm(dataIn)
    costOWPP(myOWPP)

    display(myOWPP)
    display(myOWPP.cost.results)
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
