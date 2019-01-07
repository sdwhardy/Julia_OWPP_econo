#############################################
function getCAPEX(owpp_bools, owpp_data, equip_data)
    if owpp_bools[1]==true
        if owpp_bools[2]==false
            capex=HVAC(owpp_data, equip_data)
        else
            capex=HVAC_xPlat(owpp_data, equip_data)
        end
    else
        if owpp_bools[2]==false
            capex=HVDC(owpp_data, equip_data)
        else
            capex=HVDC_xPlat(owpp_data, equip_data)
        end
    end
    return capex
end
#############################################
function HVAC(owpp_data, equip_data)
    #unpack owpp data
        S_owpp=owpp_data[1]
    #unpack equipment data
        S_xfm_pcc=equip_data[1]
        n_xfm_pcc=equip_data[2]
        S_xfm_oss=equip_data[3]
        n_xfm_oss=equip_data[4]
        l_cbl_pcc=equip_data[5]
        n_cbl_pcc=equip_data[6]
        S_cbl_pcc=equip_data[7]
        l_cbl_oss=equip_data[8]
        n_cbl_oss=equip_data[9]
        S_cbl_oss=equip_data[10]
end
#############################################
function HVAC_xPlat(owpp_data, equip_data)
    #unpack owpp data
        S_owpp=owpp_data[1]
    #unpack equipment data
        S_xfm_pcc=equip_data[1]
        n_xfm_pcc=equip_data[2]
        S_xfm_oss=equip_data[3]
        n_xfm_oss=equip_data[4]
        l_cbl_pcc=equip_data[5]
        n_cbl_pcc=equip_data[6]
        S_cbl_pcc=equip_data[7]
end
#############################################
function HVDC(owpp_data, equip_data)
    #unpack owpp data
        S_owpp=owpp_data[1]
    #unpack equipment data
        S_xfm_pcc=equip_data[1]
        n_xfm_pcc=equip_data[2]
        S_xfm_oss=equip_data[3]
        n_xfm_oss=equip_data[4]
        l_cbl_pcc=equip_data[5]
        n_cbl_pcc=equip_data[6]
        S_cbl_pcc=equip_data[7]
end
#############################################
function HVDC_xPlat(owpp_data, equip_data)
    #unpack owpp data
        S_owpp=owpp_data[1]
    #unpack equipment data
        S_xfm_pcc=equip_data[1]
        n_xfm_pcc=equip_data[2]
        S_xfm_oss=equip_data[3]
        n_xfm_oss=equip_data[4]
        l_cbl_pcc=equip_data[5]
        n_cbl_pcc=equip_data[6]
        S_cbl_pcc=equip_data[7]
        l_cbl_oss=equip_data[8]
        n_cbl_oss=equip_data[9]
        S_cbl_oss=equip_data[10]
end
#############################################
