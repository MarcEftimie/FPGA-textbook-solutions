# -Wall turns on all warningsdout
# -g2012 selects the 2012 version of iVerilog
IVERILOG=iverilog -DSIMULATION -Wall -Wno-sensitivity-entire-vector -Wno-sensitivity-entire-array -g2012 -Y.sv -I ./hdl -I ./tests 
VVP=vvp
VVP_POST=-fst
VIVADO=vivado -mode batch -source
SRCS=hdl/decoder_2_to_4.sv hdl/decoder_3_to_8.sv hdl/decoder_4_to_16.sv

# Look up .PHONY rules for Makefiles
.PHONY: clean submission remove_solutions

test_decoder_2_to_4 : testbenches/decoder_2_to_4_tb.sv ${SRCS}
	${IVERILOG} $^ -o decoder_2_to_4_tb.bin && ${VVP} decoder_2_to_4_tb.bin ${VVP_POST} && gtkwave decoder_2_to_4.fst -a testbenches/sy

test_decoder_3_to_8 : testbenches/decoder_3_to_8_tb.sv ${SRCS}
	${IVERILOG} $^ -o decoder_3_to_8_tb.bin && ${VVP} decoder_3_to_8_tb.bin ${VVP_POST} && gtkwave decoder_3_to_8.fst -a testbenches/sy

test_decoder_4_to_16 : testbenches/decoder_4_to_16_tb.sv ${SRCS}
	${IVERILOG} $^ -o decoder_4_to_16_tb.bin && ${VVP} decoder_4_to_16_tb.bin ${VVP_POST} && gtkwave decoder_4_to_16.fst -a testbenches/sy

# Call this to clean up all your generated files
clean:
	rm -f *.bin *.vcd *.fst vivado*.log *.jou vivado*.str *.log *.checkpoint *.bit *.html *.xml *.out
	rm -rf .Xil