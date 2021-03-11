transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/Diego/Desktop/lucas_processor/verilog_code {C:/Users/Diego/Desktop/lucas_processor/verilog_code/InstFetch.sv}
vlog -sv -work work +incdir+C:/Users/Diego/Desktop/lucas_processor/verilog_code {C:/Users/Diego/Desktop/lucas_processor/verilog_code/Definitions.sv}
vlog -sv -work work +incdir+C:/Users/Diego/Desktop/lucas_processor/verilog_code {C:/Users/Diego/Desktop/lucas_processor/verilog_code/data_mem.sv}
vlog -sv -work work +incdir+C:/Users/Diego/Desktop/lucas_processor/verilog_code {C:/Users/Diego/Desktop/lucas_processor/verilog_code/RegFile.sv}
vlog -sv -work work +incdir+C:/Users/Diego/Desktop/lucas_processor/verilog_code {C:/Users/Diego/Desktop/lucas_processor/verilog_code/InstROM.sv}
vlog -sv -work work +incdir+C:/Users/Diego/Desktop/lucas_processor/verilog_code {C:/Users/Diego/Desktop/lucas_processor/verilog_code/Ctrl.sv}
vlog -sv -work work +incdir+C:/Users/Diego/Desktop/lucas_processor/verilog_code {C:/Users/Diego/Desktop/lucas_processor/verilog_code/ALU.sv}
vlog -sv -work work +incdir+C:/Users/Diego/Desktop/lucas_processor/verilog_code {C:/Users/Diego/Desktop/lucas_processor/verilog_code/top_level.sv}

