// Bitonal sort
`timescale 1ns / 1ns

module step2 # (
    parameter  width = 8,
    parameter  index = 8,
    parameter  index_width = 3
) (
    input  clk,
    input  rst,

    input      [width-1:0] old_data [0:index-1],
    output reg [width-1:0] step2_data [0:index-1] 
);

    parameter index_div4 = index/4;
    parameter index_div2 = index/2;

    wire [width-1:0] step2_data_temp2 [0:index-1]; 
    generate
        for (genvar lo = 0; lo < index_div4; lo++) begin: step2_temp2_lo
            max_min  #(
                .width(width)
            )   max_min_x3 (
                .a (old_data[lo]),
                .b (old_data[lo+2]),

                .max (step2_data_temp2[lo+2]),
                .min (step2_data_temp2[lo])
            );
        end
    endgenerate

    generate
        for (genvar hi = index_div2; hi < index_div2+index_div4; hi++) begin: step2_temp2_hi
            max_min #(
                .width(width)
            )   max_min_x4 (
                .a (old_data[hi]),
                .b (old_data[hi+2]),

                .max (step2_data_temp2[hi]),
                .min (step2_data_temp2[hi+2])
            );
        end
    endgenerate




    wire [width-1:0] step2_data_temp1 [0:index-1]; 
    generate
        for (genvar lo = 0; lo < index_div2; lo = lo + 2) begin: step2_temp1_lo
            max_min  #(
                .width(width)
            )   max_min_x (
                .a (step2_data_temp2[lo]),
                .b (step2_data_temp2[lo+1]),

                .max (step2_data_temp1[lo+1]),
                .min (step2_data_temp1[lo])
            );
        end
    endgenerate

    generate
        for (genvar hi = index-1; hi > index_div2-1; hi = hi - 2) begin: step2_temp1_hi
            max_min  #(
                .width(width)
            )   max_min_x (
                .a (step2_data_temp2[hi]),
                .b (step2_data_temp2[hi-1]),

                .max (step2_data_temp1[hi-1]),
                .min (step2_data_temp1[hi])
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
                step2_data[j] <= step2_data_temp1[j];
            end
        end
    end

    
endmodule