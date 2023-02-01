# -Wall turns on all warningsdout
# -g2012 selects the 2012 version of iVerilog
IVERILOG=iverilog -DSIMULATION -Wall -Wno-sensitivity-entire-vector -Wno-sensitivity-entire-array -g2012 -Y.sv -I ./hdl -I ./tests 
VVP=vvp
VVP_POST=-fst
VIVADO=vivado -mode batch -source
SRCS=hdl/early_detection_debouncing.sv hdl/delayed_detection_debouncing.sv

# Look up .PHONY rules for Makefiles
.PHONY: clean submission remove_solutions

test_delayed_detection_debouncing : testbenches/delayed_detection_debouncing_tb.sv ${SRCS}
	${IVERILOG} $^ -o delayed_detection_debouncing_tb.bin && ${VVP} delayed_detection_debouncing_tb.bin ${VVP_POST} && gtkwave delayed_detection_debouncing.fst -a testbenches/sy

test_early_detection_debouncing : testbenches/early_detection_debouncing_tb.sv ${SRCS}
	${IVERILOG} $^ -o early_detection_debouncing_tb.bin && ${VVP} early_detection_debouncing_tb.bin ${VVP_POST} && gtkwave early_detection_debouncing.fst -a testbenches/sy

# Call this to clean up all your generated files
clean:
	rm -f *.bin *.vcd *.fst vivado*.log *.jou vivado*.str *.log *.checkpoint *.bit *.html *.xml *.out
	rm -rf .Xil
