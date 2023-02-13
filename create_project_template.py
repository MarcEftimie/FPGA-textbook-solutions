import os, shutil

# Ask User Input
project_name = input("Project Name: ")
main_file_name = input("Main File: ")
project_dir = f"{project_name}"
  
# Make Directories
os.mkdir(project_name)
os.mkdir(f"{project_name}/hdl")
os.mkdir(f"{project_name}/testbenches")

# Create Main Project File
f = open(f"{project_name}/hdl/{main_file_name}.sv", "w")
f.write(f"""
`timescale 1ns/1ps
`default_nettype none

module {main_file_name}
    #(

    ) (
        input wire clk_i, reset_i
    );

endmodule;
    """)
f.close()

# Create Makefile
f = open(f"{project_name}/Makefile", "w")
f.write(f"""
IVERILOG=iverilog -DSIMULATION -Wall -Wno-sensitivity-entire-vector -Wno-sensitivity-entire-array -g2012 -Y.sv -I ./hdl -I ./tests 
VVP=vvp
VVP_POST=-fst
VIVADO=vivado -mode batch -source
SRCS=hdl/*.sv

.PHONY: clean submission remove_solutions

clean:
rm -f *.bin *.vcd *.fst vivado*.log *.jou vivado*.str *.log *.checkpoint *.bit *.html *.xml *.out
rm -rf .Xil

###

""")
f.close()

shutil.copy("create_testbench_templates.py", f'{project_name}')

