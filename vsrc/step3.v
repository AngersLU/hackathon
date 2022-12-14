// Bitonal sort
`timescale 1ns / 1ns

module step3 # (
    parameter width = 8,
    parameter index = 8,
    parameter index_width = 3
) (
    input  clk,
    input  rst,

    input      [width-1:0] old_data [0:index-1],
    output reg [width-1:0] step3_data [0:index-1] 
);

    parameter index_div4 = index/4;
    parameter index_div2 = index/2;

// temp 3
    wire [width-1:0] step3_data_temp3 [0:index-1]; 
    generate
        for (genvar lo = 0; lo < index_div2; lo++) begin: step3_temp3_lo
            max_min #(
                .width(width)
            )   max_min_x  (
                .a (old_data[lo]),
                .b (old_data[lo+index_div2]),

                .max (step3_data_temp3[lo+index_div2]),
                .min (step3_data_temp3[lo])
            );
        end
    endgenerate



// temp 2
    wire [width-1:0] step3_data_temp2 [0:index-1]; 
    generate
        for (genvar lo = 0; lo < index_div4; lo++) begin: step2_temp2_lo
            max_min  #(
                .width(width)
            )   max_min_x (
                .a (step3_data_temp3[lo]),
                .b (step3_data_temp3[lo+2]),

                .max (step3_data_temp2[lo+2]),
                .min (step3_data_temp2[lo])
            );
        end
    endgenerate

    generate
        for (genvar hi = index_div2; hi < index_div2+index_div4; hi++) begin: step2_temp2_hi
            max_min #(
                .width(width)
            )   max_min_x (
                .a (step3_data_temp3[hi]),
                .b (step3_data_temp3[hi+2]),

                .max (step3_data_temp2[hi+2]),
                .min (step3_data_temp2[hi])
            );
        end
    endgenerate
    


//  temp 1
    wire [width-1:0] step3_data_temp1 [0:index-1]; 
    generate
        for (genvar even = 0; even < index; even = even+2) begin: step2_temp1_even
            max_min #(
                .width(width)
            )   max_min_x (
                .a (step3_data_temp2[even]),
                .b (step3_data_temp2[even+1]),

                .max (step3_data_temp1[even+1]),
                .min (step3_data_temp1[even])
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
                step3_data[j] <= step3_data_temp1[j];
            end
        end
    end

    
endmodule