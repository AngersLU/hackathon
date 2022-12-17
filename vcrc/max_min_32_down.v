
module max_min_32_down # (
    parameter width = 8
) (
    input clk,
    input rst,

    input  [width-1:0] indata [0:31],

    output [width-1:0] outdata [0:31]
);
    
    wire [width-1:0] outdata_temp [0:31];
    generate
        for (genvar i = 0; i < 16; i++) begin
            max_min #(
                .width(width)
            )   max_min_x (
                .a (indata[i]),
                .b (indata[i+16]),

                .max (outdata_temp[i]),
                .min (outdata_temp[i+16])
            );        
        end
    endgenerate

    reg [width-1:0] outdata_r [0:31];
    always @(posedge clk) begin
        if (rst) begin
            for (int i=0; i < 32; i++) begin
                outdata_r[i] <= 0;                
            end
        end
        else begin
            for (int j=0; j < 32; j++) begin
                outdata_r[j] <= outdata_temp[j];                
            end
        end
    end

    generate
        for (genvar j = 0; j < 32; j = j+16) begin: max_min_32_down_16
            max_min_16_down #(
                .width(width)
            )   max_min_16_down_x (
                .clk (clk),
                .rst (rst),
                .indata  (outdata_r[j:j+15]),
                .outdata (outdata[j:j+15])
            );
        end
    endgenerate


endmodule