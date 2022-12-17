// hackathon
`timescale 1ns / 10ps
`include "df.vh"
module ht # (
    parameter index = 32,
    parameter width = 5
) (
    input           clk,
    input           rst,

    input               start,
    input  [width-1:0]  indata  [0:index-1],

    output [width-1:0]  outdata [0:index-1],
    output              over
);

    reg [width-1:0] indata_i [0:index-1];

    always @(posedge clk) begin
        if (rst) begin
            for (int i = 0; i < index ; i++) begin
                indata_i[i] <= 0;
            end
        end
        else if (start) begin
            for (int j = 0; j < index; j++) begin
                indata_i[j] <= indata[j];
            end 
        end
    end

// step 1
    wire [width-1:0] step1_data [0:index-1];
    step1  # (
        .width(width),
        .index(index)
    )   step1_u (
        .clk (clk),
        .rst (rst),

        .old_data (indata_i),
        .step1_data (step1_data)
    );

`ifdef INDEX_2
    initial begin
        #100
		$display("step1:");
        for (int i= 0; i<index; i++) begin
            $write("%d ", step1_data[i]);
        end
		$display("");
    end
`endif

// step 2
    wire [width-1:0] step2_data [0:index-1];
    step2 # (
        .width(width),
        .index(index)
    )   step2_u (
        .clk (clk),
        .rst (rst),

        .old_data (step1_data),
        .step2_data (step2_data)
    );
`ifdef INDEX_4
	initial begin
        #100
		$display("step2:");
        for (int i= 0; i<index; i++) begin
            $write("%d ", step2_data[i]);
        end
		$display("");
    end
`endif

// step 3
    wire [width-1:0] step3_data [0:index-1];
    step3 #(
        .width(width),
        .index(index)
    )   step3_u (
        .clk (clk),
        .rst (rst),

        .old_data (step2_data),
        .step3_data (step3_data)
    );

`ifdef INDEX_8
    initial begin
        #100
		$display("step3:");
        for (int i= 0; i<index; i++) begin
            $write("%d ", step3_data[i]);
        end
		$display("");
    end
`endif

// step 4
	wire [width-1:0] step4_data [0:index-1];
    step4 #(
        .width(width),
        .index(index)
    )   step4_u (
        .clk (clk),
        .rst (rst),

        .old_data (step3_data),
        .step4_data (step4_data)
    );

`ifdef INDEX_16
    initial begin
        #100
		$display("step4:");
        for (int i= 0; i<index; i++) begin
            $write("%d ", step4_data[i]);
        end
		$display("");
    end
`endif

// step 5
	wire [width-1:0] step5_data [0:index-1];
    step5 #(
        .width(width),
        .index(index)
    )   step5_u (
        .clk (clk),
        .rst (rst),

        .old_data (step4_data),
        .step5_data (step5_data)
    );

`ifdef INDEX_32
    initial begin
        #100
		$display("step5:");
        for (int i= 0; i<index; i++) begin
            $write("%d ", step5_data[i]);
        end
		$display("");
    end
`endif

    assign outdata = step5_data;
    // assign over  = |outdata[index-1];
    assign over = 0;



endmodule
