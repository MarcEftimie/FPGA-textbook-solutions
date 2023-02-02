# -Wall turns on all warningsdout
# -g2012 selects the 2012 version of iVerilog
IVERILOG=iverilog -DSIMULATION -Wall -Wno-sensitivity-entire-vector -Wno-sensitivity-entire-array -g2012 -Y.sv -I ./hdl -I ./tests 
VVP=vvp
VVP_POST=-fst
VIVADO=vivado -mode batch -source
SRCS=hdl/*

# Look up .PHONY rules for Makefiles
.PHONY: clean submission remove_solutions

test_parking_lot_occupancy_counter : testbenches/parking_lot_occupancy_counter_tb.sv ${SRCS}
	${IVERILOG} $^ -o parking_lot_occupancy_counter_tb.bin && ${VVP} parking_lot_occupancy_counter_tb.bin ${VVP_POST} && gtkwave parking_lot_occupancy_counter.fst -a testbenches/sy

# Call this to clean up all your generated files
clean:
	rm -f *.bin *.vcd *.fst vivado*.log *.jou vivado*.str *.log *.checkpoint *.bit *.html *.xml *.out
	rm -rf .Xil
