include("data/data.jl")
include("data/structure.jl")
include("data/functions_data.jl")
include("cost/functions_cost.jl")
include("eens/functions_eens.jl")
include("post_processing/functions_pp.jl")
using DataFrames

function main()
    #OWPP basic data
    dataIn=basic_data()
    #initilaize OWPP
    myOWPP=newFarm(dataIn)
    display(myOWPP)
    costOWPP(myOWPP)
    display(myOWPP)
    display(myOWPP.eqp)
    display(myOWPP.cost.results)
    ttl=cst_ttl(myOWPP.cost.results)
    display(ttl)

    fileName=nameFile(myOWPP.plant)
    csvfile = open(fileName,"w")
    ttl2f(csvfile)
    wrt2f(csvfile,myOWPP)
    close(csvfile)
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
