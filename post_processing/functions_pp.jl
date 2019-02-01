#########################################################
function ttl2f(outFile)
	strwidth = 13
	# Print headers
	print(outFile, rpad("#1-CAP [MW]", strwidth), "\t")
	print(outFile, rpad("2-DIST [KM]", strwidth), "\t")
	print(outFile, rpad("3-TOTAL [ME]", strwidth), "\t")
	print(outFile, rpad("4-CAPEX [ME]", strwidth), "\t")
	print(outFile, rpad("5-LOSSES [ME]", strwidth), "\t")
	print(outFile, rpad("6-Q [ME]", strwidth), "\t")
	print(outFile, rpad("7-CM [ME]", strwidth), "\t")
	print(outFile, rpad("8-EENS [ME]", strwidth), "\t")
	print(outFile, rpad("9-XFMR1 [#]", strwidth), "\t")
	print(outFile, rpad("10-XFMR1 [MW]", strwidth), "\t")
	print(outFile, rpad("11-XFMR1 [ME]", strwidth), "\t")
	print(outFile, rpad("12-X1_LS [ME]", strwidth), "\t")
	print(outFile, rpad("13-CBL1 [KM]", strwidth), "\t")
	print(outFile, rpad("14-CBL1 [#]", strwidth), "\t")
	print(outFile, rpad("15-CBL1 [kV]", strwidth), "\t")
	print(outFile, rpad("16-CBL1 [MM]", strwidth), "\t")
	print(outFile, rpad("17-CBL1 [MW]", strwidth), "\t")
	print(outFile, rpad("18-CBL1 [ME]", strwidth), "\t")
	print(outFile, rpad("19-C1_L [ME]", strwidth), "\t")
	print(outFile, rpad("20-XFMR2 [#]", strwidth), "\t")
	print(outFile, rpad("21-XFMR2 [MW]", strwidth), "\t")
	print(outFile, rpad("22-XFMR2 [ME]", strwidth), "\t")
	print(outFile, rpad("23-X2_LS [ME]", strwidth), "\t")
	print(outFile, rpad("24-CBL2 [KM]", strwidth), "\t")
	print(outFile, rpad("25-CBL2 [#]", strwidth), "\t")
	print(outFile, rpad("26-CBL2 [kV]", strwidth), "\t")
	print(outFile, rpad("27-CBL2 [MM]", strwidth), "\t")
	print(outFile, rpad("28-CBL2 [MW]", strwidth), "\t")
	print(outFile, rpad("29-CBL2 [ME]", strwidth), "\t")
	print(outFile, rpad("30-C2_L [ME]", strwidth), "\t")
end
#########################################################
function wrt2f(outFile,owpp)
	strwidth = 13
	pad=4

# Print headers
#for (i, row) in df
	println(outFile)
	#print(outFile, rpad(round(owpp.plant.mva, sigdigits=strwidth-pad), strwidth), "\t")
	# Print headers
	#total=oppc+opc+tlc_pcc+tlc_oss+qc+cbc+rlc+cm+eens
	print(outFile, rpad(round(owpp.plant.mva, sigdigits=strwidth-pad), strwidth), "\t")
	print(outFile, rpad(round(owpp.plant.length, sigdigits=strwidth-pad), strwidth), "\t")
	print(outFile, rpad(round(cst_ttl(owpp.cost.results), sigdigits=strwidth-pad), strwidth), "\t")
	print(outFile, rpad(round(cst_cpx(owpp.cost.results), sigdigits=strwidth-pad), strwidth), "\t")
	print(outFile, rpad(round(cst_ls(owpp.cost.results), sigdigits=strwidth-pad), strwidth), "\t")
	print(outFile, rpad(round(owpp.cost.results.qc, sigdigits=strwidth-pad), strwidth), "\t")
	print(outFile, rpad(round(owpp.cost.results.cm, sigdigits=strwidth-pad), strwidth), "\t")
	print(outFile, rpad(round(owpp.cost.results.eens, sigdigits=strwidth-pad), strwidth), "\t")
	print(outFile, rpad(round(owpp.eqp.xfm_pcc.num, sigdigits=strwidth-pad), strwidth), "\t")
	print(outFile, rpad(round(owpp.eqp.xfm_pcc.mva, sigdigits=strwidth-pad), strwidth), "\t")
	print(outFile, rpad(round(owpp.cost.results.opc, sigdigits=strwidth-pad), strwidth), "\t")
	print(outFile, rpad(round(owpp.cost.results.tlc_pcc, sigdigits=strwidth-pad), strwidth), "\t")
	print(outFile, rpad(round(owpp.eqp.cbl_pcc.length, sigdigits=strwidth-pad), strwidth), "\t")
	print(outFile, rpad(round(owpp.eqp.cbl_pcc.num, sigdigits=strwidth-pad), strwidth), "\t")
	print(outFile, rpad(round(owpp.eqp.cbl_pcc.volt, sigdigits=strwidth-pad), strwidth), "\t")
	print(outFile, rpad(round(owpp.eqp.cbl_pcc.size, sigdigits=strwidth-pad), strwidth), "\t")
	print(outFile, rpad(round(owpp.eqp.cbl_pcc.mva, sigdigits=strwidth-pad), strwidth), "\t")
	print(outFile, rpad(round(ACDC_cbc(owpp.eqp.cbl_pcc), sigdigits=strwidth-pad), strwidth), "\t")
	print(outFile, rpad(round(owpp.cost.results.rlc, sigdigits=strwidth-pad), strwidth), "\t")
	print(outFile, rpad(round(owpp.eqp.xfm_oss.num, sigdigits=strwidth-pad), strwidth), "\t")
	print(outFile, rpad(round(owpp.eqp.xfm_oss.mva, sigdigits=strwidth-pad), strwidth), "\t")
	print(outFile, rpad(round(owpp.cost.results.oppc, sigdigits=strwidth-pad), strwidth), "\t")
	print(outFile, rpad(round(owpp.cost.results.tlc_oss, sigdigits=strwidth-pad), strwidth), "\t")
	print(outFile, rpad(round(owpp.eqp.cbl_oss.length, sigdigits=strwidth-pad), strwidth), "\t")
	print(outFile, rpad(round(owpp.eqp.cbl_oss.num, sigdigits=strwidth-pad), strwidth), "\t")
	print(outFile, rpad(round(owpp.eqp.cbl_oss.volt, sigdigits=strwidth-pad), strwidth), "\t")
	print(outFile, rpad(round(owpp.eqp.cbl_oss.size, sigdigits=strwidth-pad), strwidth), "\t")
	print(outFile, rpad(round(owpp.eqp.cbl_oss.mva, sigdigits=strwidth-pad), strwidth), "\t")
	print(outFile, rpad(round(ACDC_cbc(owpp.eqp.cbl_oss), sigdigits=strwidth-pad), strwidth), "\t")
	print(outFile, rpad(round(owpp.cost.results.rlc, sigdigits=strwidth-pad), strwidth), "\t")
#end
# writing to files

    #beautify(num, del)
    #print(outFile, df)
end
#########################################################
function nameFile(plant)
    if plant.ac == true && plant.x_plat == false
        name="results/ac_"*"Np_"*string(trunc(Int,plant.kV_pcc))*".csv"
    elseif plant.ac == true && plant.x_plat == true
        name="results/ac_"*"Xp_"*string(trunc(Int,plant.kV_pcc))*".csv"
    elseif plant.ac == false && plant.x_plat == false
        name="results/dc_"*"Np_"*string(trunc(Int,plant.kV_pcc))*".csv"
    elseif plant.ac == false && plant.x_plat == true
        name="results/dc_"*"Xp_"*string(trunc(Int,plant.kV_pcc))*".csv"
    else
        error("Unable to properly name file!")
    end
    return name
end
#########################################################
