// Bitonal sort
`timescale 1ns / 10ps

module step3 # (
    parameter width = 8,
    parameter index = 8
) (
    input  clk,
    input  rst,

    input      [width-1:0] old_data [0:index-1],
    output reg [width-1:0] step3_data [0:index-1] 
);


    wire [width-1:0] step3_data_temp [0:index-1]; 
    generate
        for (genvar lo = 0; lo < index; lo = lo+16) begin: step3_lo
            max_min_8_up #(
                .width(width)
            )   max_min_8_up_x  (
                .clk (clk),
                .rst (rst),
                .indata  (old_data[lo:lo+7]),
                .outdata (step3_data_temp[lo:lo+7])
            );
        end
    endgenerate

    generate
        for (genvar hi = 8; hi < index; hi = hi+16) begin: step3_hi
            max_min_8_down #(
                .width(width)
            )   max_min_8_down_x  (
                .clk (clk),
                .rst (rst),
                .indata  (old_data[hi:hi+7]),
                .outdata (step3_data_temp[hi:hi+7])
            );
        end
    endgenerate

    always @(posedge clk) begin
        if (rst) begin
            for (int i = 0; i < index; i++) begin
                step3_data[i] <= 0;
            end
        end
        else begin
            for (int j = 0; j < index; j++) begin
                step3_data[j] <= step3_data_temp[j];
            end
        end
    end

    
endmodule