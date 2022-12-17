
module max_min # (
    parameter width = 8
) (
    input  [width-1:0] a,
    input  [width-1:0] b,

    output [width-1:0] max,
    output [width-1:0] min
);

    wire big = a >= b;
    assign {max, min} = big ? {a, b} : {b, a};
    
endmodule