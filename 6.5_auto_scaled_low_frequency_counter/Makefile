# -Wall turns on all warningsdout
# -g2012 selects the 2012 version of iVerilog
IVERILOG=iverilog -DSIMULATION -Wall -Wno-sensitivity-entire-vector -Wno-sensitivity-entire-array -g2012 -Y.sv -I ./hdl -I ./tests 
VVP=vvp
VVP_POST=-fst
VIVADO=vivado -mode batch -source
SRCS=hdl/*

# Look up .PHONY rules for Makefiles
.PHONY: clean submission remove_solutions

test_period_counter : testbenches/period_counter_tb.sv ${SRCS}
	${IVERILOG} $^ -o period_counter_tb.bin && ${VVP} period_counter_tb.bin ${VVP_POST} && gtkwave period_counter.fst -a testbenches/sy

test_auto_scaled_low_frequency_counter : testbenches/auto_scaled_low_frequency_counter_tb.sv ${SRCS}
	${IVERILOG} $^ -o auto_scaled_low_frequency_counter_tb.bin && ${VVP} auto_scaled_low_frequency_counter_tb.bin ${VVP_POST} && gtkwave auto_scaled_low_frequency_counter.fst -a testbenches/sy

test_BCD_normalizer : testbenches/BCD_normalizer_tb.sv ${SRCS}
	${IVERILOG} $^ -o BCD_normalizer_tb.bin && ${VVP} BCD_normalizer_tb.bin ${VVP_POST} && gtkwave BCD_normalizer.fst -a testbenches/sy

test_division : testbenches/division_tb.sv ${SRCS}
	${IVERILOG} $^ -o division_tb.bin && ${VVP} division_tb.bin ${VVP_POST} && gtkwave division.fst -a testbenches/sy

test_binary_to_BCD_converter : testbenches/binary_to_BCD_converter_tb.sv ${SRCS}
	${IVERILOG} $^ -o binary_to_BCD_converter_tb.bin && ${VVP} binary_to_BCD_converter_tb.bin ${VVP_POST} && gtkwave binary_to_BCD_converter.fst -a testbenches/sy

# Call this to clean up all your generated files
clean:
	rm -f *.bin *.vcd *.fst vivado*.log *.jou vivado*.str *.log *.checkpoint *.bit *.html *.xml *.out
	rm -rf .Xil
