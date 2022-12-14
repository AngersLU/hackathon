
`timescale 1ns / 1ps

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
	// parameter a = $random;
	// parameter b = {{$random}%9};
	// parameter num1 = 2**a, 
	// parameter num2 = 2**b;
	parameter width = 4;
	parameter index  = 8;
	parameter index_width = $clog2(index);
	// TODO:

// start
	reg  [width-1:0] indata  [0:index-1];
	reg  start;
	initial begin
		$readmemh("indata.txt", indata);
		for (int i = 0; i<index; i++) begin
				$display("%h", indata[i]);
		end
		start <= 1;
	end

// ht
	wire [width-1:0] outdata [0:index-1];
	wire over;
	ht #(	.index(index),
			.width(width),
			.index_width(index_width)
	)	ht_u (
		.clk (clk),
		.rst (~rst_n),
		
		.start	 (start),
		.indata  (indata),
		.outdata (outdata),
		.over	 (over)
	);

// over
	//TODO:DPI-C  C vs verilog
	initial begin
		if (start & rst_n) begin
			#4 
			for (int i = 0; i<index; i++) begin
				$display("%h", outdata[i]);
			end
			$finish;
		end
	end


endmodule

