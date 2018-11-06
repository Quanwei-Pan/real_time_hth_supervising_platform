# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "PROBE_GROUP" -parent ${Page_0}
  ipgui::add_static_text $IPINST -name "rang_description" -parent ${Page_0} -text {0: 00 ~ 07

1: 08 ~ 15

2 : 16 ~ 23

3:  24 ~ 31

4: 32 ~ 39

5: 40 ~ 47

6: 48 ~ 55

7: 56 ~ 63}


}

proc update_PARAM_VALUE.PROBE_GROUP { PARAM_VALUE.PROBE_GROUP } {
	# Procedure called to update PROBE_GROUP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PROBE_GROUP { PARAM_VALUE.PROBE_GROUP } {
	# Procedure called to validate PROBE_GROUP
	return true
}


proc update_MODELPARAM_VALUE.PROBE_GROUP { MODELPARAM_VALUE.PROBE_GROUP PARAM_VALUE.PROBE_GROUP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PROBE_GROUP}] ${MODELPARAM_VALUE.PROBE_GROUP}
}

