
// Bitonal sort
`timescale 1ns / 1ns

module step1 # (
    parameter  width = 8,
    parameter  index = 8,
    parameter  index_width = 3
) (
    input  clk,
    input  rst,

    input       [width-1:0] old_data [0:index-1],
    output reg  [width-1:0] step1_data [0:index-1] 
);

    wire [width-1:0] step1_data_temp [0:index-1]; 
    generate
        for (genvar even = 0; even < index; even = even + 2) begin: step_1_even
            max_min #(
                .width(width)
            )   max_min_x1 (
                .a (old_data[even]),
                .b (old_data[even+1]),

                .max (step1_data_temp[even+1]),
                .min (step1_data_temp[even])
            );
        end
    endgenerate

    generate
        for (genvar odd = 2; odd < index; odd = odd + 2) begin: step_1_odd
            max_min #(
                .width(width)
            )   max_min_x2 (
                .a (old_data[odd]),
                .b (old_data[odd+1]),

                .max (step1_data_temp[odd]),
                .min (step1_data_temp[odd+1])
            );
        end
    endgenerate

    always @(posedge clk) begin
        if (rst) begin
            for (int i = 0; i < index; i++) begin
                step1_data[i] <= 0;
            end
        end
        else begin
            for (int j = 0; j < index; j++) begin
                step1_data[j] <= step1_data_temp[j];
            end
        end
    end

    
endmodule