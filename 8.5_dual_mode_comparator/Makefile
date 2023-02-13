
IVERILOG=iverilog -DSIMULATION -Wall -Wno-sensitivity-entire-vector -Wno-sensitivity-entire-array -g2012 -Y.sv -I ./hdl -I ./tests 
VVP=vvp
VVP_POST=-fst
VIVADO=vivado -mode batch -source
SRCS=hdl/*.sv

.PHONY: clean submission remove_solutions

clean:
	rm -f *.bin *.vcd *.fst vivado*.log *.jou vivado*.str *.log *.checkpoint *.bit *.html *.xml *.out
	rm -rf .Xil

test_dual_mode_comparator : testbenches/dual_mode_comparator_tb.sv hdl/*
	${IVERILOG} $^ -o dual_mode_comparator_tb.bin && ${VVP} dual_mode_comparator_tb.bin ${VVP_POST} && gtkwave dual_mode_comparator.fst -a testbenches/sy

