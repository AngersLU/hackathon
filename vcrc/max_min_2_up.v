
module max_min_2_up # (
    parameter width = 8
) (
    input  [width-1:0] indata [0:1],

    output [width-1:0] outdata [0:1]
);
    
    max_min #(
        .width(width)
    )   max_min_1 (
        .a (indata[0]),
        .b (indata[1]),

        .max (outdata[1]),
        .min (outdata[0])
    );
    
endmodule