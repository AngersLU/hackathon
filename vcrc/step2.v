// Bitonal sort
`timescale 1ns / 10ps

module step2 # (
    parameter  width = 8,
    parameter  index = 8
) (
    input  clk,
    input  rst,

    input      [width-1:0] old_data [0:index-1],
    output reg [width-1:0] step2_data [0:index-1] 
);


    wire [width-1:0] step2_data_temp [0:index-1]; 
    generate
        for (genvar lo = 0; lo < index; lo = lo+8) begin: step2_temp_lo
            max_min_4_up #(
                .width(width)
            )   max_min_x (
                .clk (clk),
                .rst (rst),
                .indata  (old_data[lo:lo+3]),
                .outdata (step2_data_temp[lo:lo+3])
            );
        end
    endgenerate

    generate
        for (genvar hi = 4; hi < index; hi = hi+8) begin: step2_temp_hi
            max_min_4_down #(
                .width(width)
            )   max_min_4_down (
                .clk (clk),
                .rst (rst),
                .indata  (old_data[hi:hi+3]),
                .outdata (step2_data_temp[hi:hi+3])
            );
        end
    endgenerate


    always @(posedge clk) begin
        if (rst) begin
            for (int i = 0; i < index; i++) begin
                step2_data[i] <= 0;
            end
        end
        else begin
            for (int j = 0; j < index; j++) begin
                step2_data[j] <= step2_data_temp[j];
            end
        end
    end

    
endmodule