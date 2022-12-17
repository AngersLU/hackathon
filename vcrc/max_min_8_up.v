
module max_min_8_up # (
    parameter width = 8
) (
    input clk,
    input rst,

    input  [width-1:0] indata [0:7],

    output [width-1:0] outdata [0:7]
);
    
    wire [width-1:0] outdata_temp [0:7];
    generate
        for (genvar i = 0; i < 4; i++) begin
            max_min #(
                .width(width)
            )   max_min_x (
                .a (indata[i]),
                .b (indata[i+4]),

                .max (outdata_temp[i+4]),
                .min (outdata_temp[i])
            );        
        end
    endgenerate

    reg [width-1:0] outdata_r [0:7];
    always @(posedge clk) begin
        if (rst) begin
            for (int i=0; i < 8; i++) begin
                outdata_r[i] <= 0;                
            end
        end
        else begin
            for (int j=0; j < 8; j++) begin
                outdata_r[j] <= outdata_temp[j];                
            end
        end
    end

    generate
        for (genvar j = 0; j < 8; j = j+4) begin: max_min_8_up_4
            max_min_4_up #(
                .width(width)
            )   max_min_4_up_x (
                .clk (clk),
                .rst (rst),
                .indata  (outdata_r[j:j+3]),
                .outdata (outdata[j:j+3])
            );
        end
    endgenerate


endmodule