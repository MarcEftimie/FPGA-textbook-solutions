# -Wall turns on all warningsdout
# -g2012 selects the 2012 version of iVerilog
IVERILOG=iverilog -DSIMULATION -Wall -Wno-sensitivity-entire-vector -Wno-sensitivity-entire-array -g2012 -Y.sv -I ./hdl -I ./tests 
VVP=vvp
VVP_POST=-fst
VIVADO=vivado -mode batch -source
SRCS=hdl/rotating_led_banner.sv hdl/time_multiplexer.sv hdl/parameterized_barrel_shifter.sv hdl/hex_to_7_segment.sv

# Look up .PHONY rules for Makefiles
.PHONY: clean submission remove_solutions

test_rotating_led_banner : testbenches/rotating_led_banner_tb.sv ${SRCS}
	${IVERILOG} $^ -o rotating_led_banner_tb.bin && ${VVP} rotating_led_banner_tb.bin ${VVP_POST} && gtkwave rotating_led_banner.fst -a testbenches/sy

# Call this to clean up all your generated files
clean:
	rm -f *.bin *.vcd *.fst vivado*.log *.jou vivado*.str *.log *.checkpoint *.bit *.html *.xml *.out
	rm -rf .Xil