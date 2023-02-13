# Very crude file that generates testbenches

import os

sv_files = []

for root, dirs, files in os.walk("hdl/"):
    sv_files = files

write_lines = []

default_lines = """
IVERILOG=iverilog -DSIMULATION -Wall -Wno-sensitivity-entire-vector -Wno-sensitivity-entire-array -g2012 -Y.sv -I ./hdl -I ./tests 
VVP=vvp
VVP_POST=-fst
VIVADO=vivado -mode batch -source
SRCS=hdl/*.sv

.PHONY: clean submission remove_solutions

clean:
rm -f *.bin *.vcd *.fst vivado*.log *.jou vivado*.str *.log *.checkpoint *.bit *.html *.xml *.out
rm -rf .Xil

"""

for idx, sv_file in enumerate(sv_files):
    f = open(f"hdl/{sv_files[idx]}")
    lines = f.readlines()
    write_lines.append([])
    line_idx = 1
    write_lines[idx].append([])
    write_lines[idx].append([])
    write_lines[idx].append([])
    for line in lines:
        if ("parameter" in line):
            write_lines[idx][0].append(line.lstrip().rstrip(",\n"))
            line_idx += 1
        if ("input" in line):
            write_lines[idx][1].append(line.lstrip("input wire ").rstrip(",\n"))
            line_idx += 1
        if ("output" in line):
            write_lines[idx][2].append(line.lstrip("output logic ").rstrip(",\n"))
            line_idx += 1
    io_declarations = ""
    parameter_declarations = ""
    for parameters in write_lines[idx][0]:
        io_declarations += f"\n    {parameters};"
        param = parameters.lstrip("parameter ").split(" = ", 1)[0]
        parameter_declarations += f"\n        .{param}({param}),"
    for inputs in write_lines[idx][1]:
        io_declarations += f"\n    logic {inputs};"
    for outputs in write_lines[idx][2]:
        io_declarations += f"\n    wire {outputs};"
    io_declarations = io_declarations.removesuffix(",")
    parameter_declarations = parameter_declarations.removesuffix(",")
    
    f.close()
    
    f = open(f"testbenches/{sv_files[idx][0:-3]}_tb.sv", "w+")
    f.write(f"""
`timescale 1ns/1ps
`default_nettype none

module {sv_files[idx][0:-3]}_tb;

    parameter CLK_PERIOD_NS = 10;
    {io_declarations}

    {sv_files[idx][0:-3]} #({parameter_declarations}
    ) UUT(
        .*
    );

    always #(CLK_PERIOD_NS/2) clk_i = ~clk_i;

    initial begin
        $dumpfile("{sv_files[idx][0:-3]}.fst");
        $dumpvars(0, UUT);
        clk_i = 0;
        reset_i = 1;
        repeat(1) @(negedge clk_i);
        reset_i = 0;
        $finish;
    end

endmodule""")
    f.close()

    ff = open("Makefile", "w+")
    default_lines += f"test_{sv_files[idx][0:-3]} : testbenches/{sv_files[idx][0:-3]}_tb.sv hdl/*\n${{IVERILOG}} $^ -o {sv_files[idx][0:-3]}_tb.bin && ${{VVP}} {sv_files[idx][0:-3]}_tb.bin ${{VVP_POST}} && gtkwave {sv_files[idx][0:-3]}.fst -a testbenches/sy\n\n"
    ff.writelines(default_lines)
    ff.close()
