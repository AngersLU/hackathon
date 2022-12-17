// Bitonal sort
`timescale 1ns / 10ps

module step4 # (
    parameter width = 8,
    parameter index = 8
) (
    input  clk,
    input  rst,

    input      [width-1:0] old_data [0:index-1],
    output reg [width-1:0] step4_data [0:index-1] 
);

    wire [width-1:0] step4_data_temp [0:index-1]; 
    generate
        for (genvar lo = 0; lo < index; lo = lo+32) begin: step4_lo
            max_min_16_up #(
                .width(width)
            )   max_min_16_up_x  (
                .clk (clk),
                .rst (rst),
                .indata  (old_data[lo:lo+15]),
                .outdata (step4_data_temp[lo:lo+15])
            );
        end
    endgenerate

    generate
        for (genvar hi = 16; hi < index; hi = hi+32) begin: step4_hi
            max_min_16_down #(
                .width(width)
            )   max_min_16_down_x  (
                .clk (clk),
                .rst (rst),
                .indata  (old_data[hi:hi+15]),
                .outdata (step4_data_temp[hi:hi+15])
            );
        end
    endgenerate

    always @(posedge clk) begin
        if (rst) begin
            for (int i = 0; i < index; i++) begin
                step4_data[i] <= 0;
            end
        end
        else begin
            for (int j = 0; j < index; j++) begin
                step4_data[j] <= step4_data_temp[j];
            end
        end
    end

    
endmodule