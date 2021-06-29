`include "../rtl/tiny_alu.sv"

module top_tb;

logic [7:0] A_i, B_i, res_o;
logic       clk_i, rst_n_i, done_o, start_i;
logic [2:0] oper_i;

tiny_alu dut ( .* );
tb_tiny_alu tb ( .* );

initial begin
  $dumpfile("dump.vcd");
  $dumpvars;
  $monitor($stime,, done_o,, res_o);
  clk_i = 0;
  rst_n_i = 0;
  rst_n_i <= #1 1;
  forever #5 clk_i = ~clk_i;
end

initial #150 $finish;

endmodule



//------------------------------------------------------------//

program tb_tiny_alu (
  input logic         clk_i, rst_n_i, done_o,
  input logic   [7:0] res_o,
  output logic  [7:0] A_i, B_i,
  output logic  [2:0] oper_i,
  output logic        start_i
  );

enum {
  OP_ADD,
  OP_SUB,
  OP_MUL,
  OP_OR,
  OP_AND,
  OP_NOT,
  OP_NOP,
  OP_RST
} oper;

initial begin
  #10;
  A_i = 4;
  B_i = 37;
  oper_i = OP_MUL;
  start_i = 1;
  #10;
  start_i = 0;
end

endprogram: tb_tiny_alu





