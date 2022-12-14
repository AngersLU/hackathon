// hackathon
`timescale 1ns / 1ns

module ht # (
    parameter index = 8,
    parameter width = 8,
    parameter index_width = 3
) (
    input           clk,
    input           rst,

    input               start,
    input  [width-1:0]  indata  [0:index-1],

    output [width-1:0]  outdata [0:index-1],
    output              over
);

    reg [width-1:0] indata_i [0:index-1];

    reg over_i; 

    always @(posedge clk) begin
        if (rst) begin
            for (int i = 0; i < index ; i++) begin
                indata_i[i] <= 0;
            end
        end
        else if (start) begin
            for (int j = 0; j < index; j++) begin
                indata_i[j] <= indata[j];
            end 
        end
    end

// step 1
    wire [width-1:0] step1_data [0:index-1];
    step1  # (
        .width(width),
        .index(index),
        .index_width(index_width)
    )   step1_u (
        .clk (clk),
        .rst (rst),

        .old_data (indata_i),
        .step1_data (step1_data)
    );

// step 2
    wire [width-1:0] step2_data [0:index-1];
    step2 # (
        .width(width),
        .index(index),
        .index_width(index_width)
    )   step2_u (
        .clk (clk),
        .rst (rst),

        .old_data (step1_data),
        .step2_data (step2_data)
    );
 
// step 3
    wire [width-1:0] step3_data [0:index-1];
    step3 #(
        .width(width),
        .index(index),
        .index_width(index_width)
    )   step3_u (
        .clk (clk),
        .rst (rst),

        .old_data (step2_data),
        .step3_data (step3_data)
    );

    assign outdata = step3_data;

    assign over  = 1'b0;

endmodule
