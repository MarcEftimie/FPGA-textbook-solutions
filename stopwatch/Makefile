# -Wall turns on all warningsdout
# -g2012 selects the 2012 version of iVerilog
IVERILOG=iverilog -DSIMULATION -Wall -Wno-sensitivity-entire-vector -Wno-sensitivity-entire-array -g2012 -Y.sv -I ./hdl -I ./tests 
VVP=vvp
VVP_POST=-fst
VIVADO=vivado -mode batch -source
SRCS=hdl/stopwatch.sv hdl/time_multiplexer.sv hdl/hex_to_7_segment.sv hdl/debouncer.sv

# Look up .PHONY rules for Makefiles
.PHONY: clean submission remove_solutions

test_stopwatch : testbenches/stopwatch_tb.sv ${SRCS}
	${IVERILOG} $^ -o stopwatch_tb.bin && ${VVP} stopwatch_tb.bin ${VVP_POST} && gtkwave stopwatch.fst -a testbenches/sy

test_debouncer : testbenches/debouncer_tb.sv ${SRCS}
	${IVERILOG} $^ -o debouncer_tb.bin && ${VVP} debouncer_tb.bin ${VVP_POST} && gtkwave debouncer.fst -a testbenches/sy

# Call this to clean up all your generated files
clean:
	rm -f *.bin *.vcd *.fst vivado*.log *.jou vivado*.str *.log *.checkpoint *.bit *.html *.xml *.out
	rm -rf .Xil
