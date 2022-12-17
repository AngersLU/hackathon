module max_min_4_down # (
    parameter width = 8
) (
    input clk,
    input rst,

    input  [width-1:0] indata [0:3],

    output [width-1:0] outdata [0:3]
);

    wire [width-1:0] outdata_temp [0:3];
    generate
        for (genvar i = 0; i<2; i++) begin
            max_min #(
                .width(width)
            )   max_min_4_1 (
                .a (indata[i]),
                .b (indata[i+2]),

                .max (outdata_temp[i]),
                .min (outdata_temp[i+2])
            );
        end
    endgenerate
    
    reg [width-1:0] outdata_r [0:3];
    always @(posedge clk) begin
        if (rst) begin
            for (int i=0; i < 4; i++) begin
                outdata_r[i] <= 0;                
            end
        end
        else begin
            for (int j=0; j < 4; j++) begin
                outdata_r[j] <= outdata_temp[j];                
            end
        end
    end

    generate
        for (genvar i = 0; i<4; i= i+2) begin
            max_min #(
                .width(width)
            )   max_min_4_down_2 (
                .a (outdata_r[i]),
                .b (outdata_r[i+1]),

                .max (outdata[i]),
                .min (outdata[i+1])
            );
        end
    endgenerate


endmodule