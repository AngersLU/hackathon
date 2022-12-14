// hackathon
`timescale 1ns / 1ps


module ht # (
    parameter index = 8,
    parameter width = 8
) (
    input           clk,
    input           rst,

    input           start,
    input  [width-1:0]  indata  [0:index-1],

    output [width-1:0]  outdata [0:index-1],
    output          over
);

    reg [width-1:0] indata_i [0:index-1];

    reg over_i; 

    always @(posedge clk) begin
        if (rst) begin
            for (int i = 0; i < index ; i++) begin
                indata_i[i] <= width'b0;
            end
        end
        else if (start) begin
            for (int j = 0; j < index; j++) begin
                indata_i[j] <= indata[j];
            end 
        end
    end






    assign over  = over_i;

endmodule
