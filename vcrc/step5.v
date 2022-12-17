// Bitonal sort
`timescale 1ns / 10ps

module step5 # (
    parameter width = 8,
    parameter index = 8
) (
    input  clk,
    input  rst,

    input      [width-1:0] old_data [0:index-1],
    output reg [width-1:0] step5_data [0:index-1] 
);

    wire [width-1:0] step5_data_temp [0:index-1]; 
    generate
        for (genvar lo = 0; lo < index; lo = lo+64) begin: step5_lo
            max_min_32_up #(
                .width(width)
            )   max_min_32_up_x  (
                .clk (clk),
                .rst (rst),
                .indata  (old_data[lo:lo+31]),
                .outdata (step5_data_temp[lo:lo+31])
            );
        end
    endgenerate

    generate
        for (genvar hi = 32; hi < index; hi = hi+64) begin: step5_hi
            max_min_32_down #(
                .width(width)
            )   max_min_32_down_x  (
                .clk (clk),
                .rst (rst),
                .indata  (old_data[hi:hi+31]),
                .outdata (step5_data_temp[hi:hi+31])
            );
        end
    endgenerate

    always @(posedge clk) begin
        if (rst) begin
            for (int i = 0; i < index; i++) begin
                step5_data[i] <= 0;
            end
        end
        else begin
            for (int j = 0; j < index; j++) begin
                step5_data[j] <= step5_data_temp[j];
            end
        end
    end

    
endmodule