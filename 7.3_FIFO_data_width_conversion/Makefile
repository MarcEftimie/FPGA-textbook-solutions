# -Wall turns on all warningsdout
# -g2012 selects the 2012 version of iVerilog
IVERILOG=iverilog -DSIMULATION -Wall -Wno-sensitivity-entire-vector -Wno-sensitivity-entire-array -g2012 -Y.sv -I ./hdl -I ./tests 
VVP=vvp
VVP_POST=-fst
VIVADO=vivado -mode batch -source
SRCS=hdl/*.sv

# Look up .PHONY rules for Makefiles
.PHONY: clean submission remove_solutions

test_FIFO_controller_width_conversion : testbenches/FIFO_controller_width_conversion_tb.sv hdl/FIFO_controller_width_conversion.sv
	${IVERILOG} $^ -o FIFO_controller_width_conversion_tb.bin && ${VVP} FIFO_controller_width_conversion_tb.bin ${VVP_POST} && gtkwave FIFO_controller_width_conversion.fst -a testbenches/sy

test_FIFO_controller : testbenches/FIFO_controller_tb.sv ${SRCS}
	${IVERILOG} $^ -o FIFO_controller_tb.bin && ${VVP} FIFO_controller_tb.bin ${VVP_POST} && gtkwave FIFO_controller.fst -a testbenches/sy

test_FIFO_data_width_converter : testbenches/FIFO_data_width_converter_tb.sv hdl/*
	${IVERILOG} $^ -o FIFO_data_width_converter_tb.bin && ${VVP} FIFO_data_width_converter_tb.bin ${VVP_POST} && gtkwave FIFO_data_width_converter.fst -a testbenches/sy

# Call this to clean up all your generated files
clean:
	rm -f *.bin *.vcd *.fst vivado*.log *.jou vivado*.str *.log *.checkpoint *.bit *.html *.xml *.out
	rm -rf .Xil
