
module max_min_16_down # (
    parameter width = 8
) (
    input clk,
    input rst,

    input  [width-1:0] indata [0:15],

    output [width-1:0] outdata [0:15]
);
    
    wire [width-1:0] outdata_temp [0:15];
    generate
        for (genvar i = 0; i < 8; i++) begin
            max_min #(
                .width(width)
            )   max_min_x (
                .a (indata[i]),
                .b (indata[i+8]),

                .max (outdata_temp[i]),
                .min (outdata_temp[i+8])
            );        
        end
    endgenerate

    reg [width-1:0] outdata_r [0:15];
    always @(posedge clk) begin
        if (rst) begin
            for (int i=0; i < 16; i++) begin
                outdata_r[i] <= 0;                
            end
        end
        else begin
            for (int j=0; j < 16; j++) begin
                outdata_r[j] <= outdata_temp[j];                
            end
        end
    end

    generate
        for (genvar j = 0; j < 16; j = j+8) begin: max_min_16_down_8
            max_min_8_down #(
                .width(width)
            )   max_min_8_down_x (
                .clk (clk),
                .rst (rst),
                .indata  (outdata_r[j:j+7]),
                .outdata (outdata[j:j+7])
            );
        end
    endgenerate


endmodule