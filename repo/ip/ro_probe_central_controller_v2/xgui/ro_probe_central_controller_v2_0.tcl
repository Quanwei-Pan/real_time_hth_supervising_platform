# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  set TS [ipgui::add_param $IPINST -name "TS" -parent ${Page_0}]
  set_property tooltip {clk 125MHz} ${TS}


}

proc update_PARAM_VALUE.TS { PARAM_VALUE.TS } {
	# Procedure called to update TS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TS { PARAM_VALUE.TS } {
	# Procedure called to validate TS
	return true
}


proc update_MODELPARAM_VALUE.TS { MODELPARAM_VALUE.TS PARAM_VALUE.TS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TS}] ${MODELPARAM_VALUE.TS}
}

