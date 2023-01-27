# -Wall turns on all warningsdout
# -g2012 selects the 2012 version of iVerilog
IVERILOG=iverilog -DSIMULATION -Wall -Wno-sensitivity-entire-vector -Wno-sensitivity-entire-array -g2012 -Y.sv -I ./hdl -I ./tests 
VVP=vvp
VVP_POST=-fst
VIVADO=vivado -mode batch -source
SRCS=hdl/int_to_float_converter.sv hdl/float_to_int_converter.sv

# Look up .PHONY rules for Makefiles
.PHONY: clean submission remove_solutions

test_int_to_float_converter : testbenches/int_to_float_converter_tb.sv ${SRCS}
	${IVERILOG} $^ -o int_to_float_converter_tb.bin && ${VVP} int_to_float_converter_tb.bin ${VVP_POST} && gtkwave int_to_float_converter.fst -a testbenches/sy

test_float_to_int_converter : testbenches/float_to_int_converter_tb.sv ${SRCS}
	${IVERILOG} $^ -o float_to_int_converter_tb.bin && ${VVP} float_to_int_converter_tb.bin ${VVP_POST} && gtkwave float_to_int_converter.fst -a testbenches/sy

# Call this to clean up all your generated files
clean:
	rm -f *.bin *.vcd *.fst vivado*.log *.jou vivado*.str *.log *.checkpoint *.bit *.html *.xml *.out
	rm -rf .Xil