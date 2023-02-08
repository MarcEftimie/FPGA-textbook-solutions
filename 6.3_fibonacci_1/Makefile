# -Wall turns on all warningsdout
# -g2012 selects the 2012 version of iVerilog
IVERILOG=iverilog -DSIMULATION -Wall -Wno-sensitivity-entire-vector -Wno-sensitivity-entire-array -g2012 -Y.sv -I ./hdl -I ./tests 
VVP=vvp
VVP_POST=-fst
VIVADO=vivado -mode batch -source
SRCS=hdl/*.sv

# Look up .PHONY rules for Makefiles
.PHONY: clean submission remove_solutions

test_fibonacci_generator : testbenches/fibonacci_generator_tb.sv ${SRCS}
	${IVERILOG} $^ -o fibonacci_generator_tb.bin && ${VVP} fibonacci_generator_tb.bin ${VVP_POST} && gtkwave fibonacci_generator.fst -a testbenches/sy

test_fibonacci_top : testbenches/fibonacci_top_tb.sv ${SRCS}
	${IVERILOG} $^ -o fibonacci_top_tb.bin && ${VVP} fibonacci_top_tb.bin ${VVP_POST} && gtkwave fibonacci_top.fst -a testbenches/sy

# Call this to clean up all your generated files
clean:
	rm -f *.bin *.vcd *.fst vivado*.log *.jou vivado*.str *.log *.checkpoint *.bit *.html *.xml *.out
	rm -rf .Xil
