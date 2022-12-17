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
	bit [width-1:0] exp [0:`INDEX-1];

// start
	reg  [width-1:0] indata  [0:index-1];
	reg  start;
	initial begin
		$readmemh("indata.txt", indata);
		$display("start:");
		foreach (indata[i]) begin
			$write("%d ", indata[i]);
		end
		$display("");
		foreach (indata[i])begin
			exp[i] = indata[i];
		end
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
function void Print(bit [width-1:0] p [0:`INDEX-1]);
	foreach(p[i]) begin
		$write("%d ",  p[i]);
	end
	$display("");
endfunction

function void Compare(input bit [width-1:0] a [0:`INDEX-1],input bit [width-1:0] b [0:`INDEX-1]);
	bit [`INDEX-1:0] com;
	foreach (a[i])begin
		com[i] = a[i]!=b[i];
	end
	if (|com) $display("Error!");
	else $display("\nPass!\n");
endfunction

	initial begin
		#200 begin
			// QuickSort(exp, 0, `INDEX-1);
			exp.sort();
			$display("ref:");
			Print(exp);
			Compare(exp, outdata);
			$finish(0);
		end 
	end


endmodule




// function automatic void QuickSort(ref bit [width-1:0] p [0:`INDEX-1], input int left, input int right);	
// 	bit [width-1:0] pivot = p[left];
// 	int i = left, j = right;
	
// 	if (left >= right) return ;
	
// 	while (i < j) begin
// 		while (i < j && p[j] >= pivot) begin
// 			j--;
// 		end
// 		p[i] = p[j];
		
// 		while (i < j && p[i] < pivot) begin
// 			i++;
// 		end
// 		p[j] = p[i];
// 	end
// 	p[i] = pivot;
	
// 	QuickSort(p, left, i-1);
// 	QuickSort(p, i+1, right);
// endfunction
