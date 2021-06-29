module tiny_alu (
  input logic         clk_i, rst_n_i,
  input logic         start_i,
  input logic   [2:0] oper_i,
  input logic   [7:0] A_i, B_i,
  output  logic [7:0] res_o,
  output  logic       comp_res_o,
  output  logic       done_i
  );

logic [2:0] cnt;
logic [7:0] B_d, res_comb;
logic [15:0] A_d, res;

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

always_comb begin
  case (oper_i)
    OP_ADD: begin
      {comp_res_o, res_comb} = A_i + B_i;
    end

    OP_SUB: begin
      {comp_res_o, res_comb} = A_i - B_i;
    end

    OP_OR: begin
      res_comb = A_i | B_i;
      comp_res_o = 0;
    end

    OP_AND: begin
      res_comb = A_i & B_i;
      comp_res_o = 0;
    end

    OP_NOT: begin
      res_comb = ~A_i;
      comp_res_o = 0;
    end

    OP_NOP: begin
      res_comb = 0;
      comp_res_o = 0;
    end

    OP_RST: begin
      res_comb = 0;
      comp_res_o = 0;
    end

    default: comp_res_o = |res[8:15];
  endcase
end


always_ff @(posedge clk_i or negedge rst_n_i) begin
  if(~rst_n_i) begin
    cnt <= 3'b0;
    B_d <= 8'b0;
    A_d <= 16'b0;
    res <= 16'b0;
  end else begin
    if (start & ~|cnt) begin
      cnt <= cnt + 1;
      res <={8'b0, A_i & {8{B_i[0]}}};
      A_d <= {7'b0, A_i, 1'b0};
      B_d <= {1'b0, B_i[8:1]};
    end else if (|cnt) begin
      res <= res + (A_d & {16{B_i[0]}});
      B_d <= {1'b0}, B_d[8:1]};
      A_d <= {A_d[14:0], 1'b0};
      cnt <= cnt + 1;
    end
  end
end

assign {done_i, res_o} = (oper_i == OP_MUL) ? {&cnt, res[7:0}] : {1'b1, res_comb};

endmodule: timy_alu
