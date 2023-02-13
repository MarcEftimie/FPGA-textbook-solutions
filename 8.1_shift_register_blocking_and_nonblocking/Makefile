
IVERILOG=iverilog -DSIMULATION -Wall -Wno-sensitivity-entire-vector -Wno-sensitivity-entire-array -g2012 -Y.sv -I ./hdl -I ./tests 
VVP=vvp
VVP_POST=-fst
VIVADO=vivado -mode batch -source
SRCS=hdl/*.sv

.PHONY: clean submission remove_solutions

clean:
	rm -f *.bin *.vcd *.fst vivado*.log *.jou vivado*.str *.log *.checkpoint *.bit *.html *.xml *.out
	rm -rf .Xil

test_shift_register_blocking_and_nonblocking : testbenches/shift_register_blocking_and_nonblocking_tb.sv hdl/*
	${IVERILOG} $^ -o shift_register_blocking_and_nonblocking_tb.bin && ${VVP} shift_register_blocking_and_nonblocking_tb.bin ${VVP_POST} && gtkwave shift_register_blocking_and_nonblocking.fst -a testbenches/sy

