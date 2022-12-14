
`timescale 1ns / 1ps

module tb (

);
 
	reg rst_n;
	reg clk;

// rst
	initial begin
		rst_n = 0;
		repeat(1024) @(posedge clk);
		#100
		rsr_n = 1;	
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
	end

// wave
	initial begin
		$dumpfile("tb.vcd");
	  	$dumpvars(0,tb);
	end

// rand 
	parameter a = {$rabdom}%10;
	parameter b = {$rabdom}%10;
	// parameter num1 = 2**a, 
	// parameter num2 = 2**b;
	parameter width = 4;
	parameter index  = 16;
	// TODO:

// start
	reg  [width-1:0] indata  [0:index-1];
	reg start;
	initial begin
		$readmemh("indata.txt", indata);
		start <= 1;
	end

// ht
	ht ht_u #(.m = ,
				.n = num2
	) (
		.clk (clk),
		.rst (~rst_n)
		
		.start	 (start),
		.indata  (indata),
		.outdata (outdata),
		.over	 (over)
	);

// over
	wire over;
	wire [width-1:0] outdata [0:index-1];
	//TODO:DPI-C  C vs verilog
	initial begin
		if (over) #100 $finish;
	end


endmodule

