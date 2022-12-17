`timescale 1ns / 10ps
`include "df.vh"
module tb (
);
	reg rst_n;
	reg clk;

// rst
	initial begin
		clk = 0;
		rst_n = 0;
		#5
		rst_n = 1;	
	end

// clk
	always begin
		if($test$plusargs("25m"))
			#20.000 clk <= ~clk; // 25Mhz
		else if($test$plusargs("50m"))
			#10.000 clk <= ~clk;
		else if($test$plusargs("100m"))
			#5.000  clk <= ~clk;
		else if($test$plusargs("200m"))
			#2.500  clk <= ~clk; 
		else begin
			#2.500 clk <= ~clk;			
		end
	end

// wave
	initial begin
		$dumpfile("tb.vcd");
	  	$dumpvars(0,tb);
	end

// rand 
	parameter width = 5;
	parameter index  = `INDEX;
	// TODO: +握手 -> 控制lvs比例

// start
	reg  [width-1:0] indata  [0:index-1];
	reg  start;
	initial begin
		$readmemh("indata.txt", indata);
		$display("start");
		for (int i = 0; i<index; i++) begin
			$write("%d ", indata[i]);
		end
		$display("");
		start <= 1;
	end

// ht
	wire [width-1:0] outdata [0:index-1];
	wire over;
	ht #(	.index(index),
			.width(width)
	)	ht_u (
		.clk (clk),
		.rst (~rst_n),
		
		.start	 (start),
		.indata  (indata),
		.outdata (outdata),
		.over	 (over)
	);

// over
	initial begin
		#200 begin
			$finish(0);
		end 
	end


endmodule

