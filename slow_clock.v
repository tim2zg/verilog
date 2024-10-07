module slow_clock (
    input clk,
    output slow_clk
);

    reg [10:0] counter = 0;
    always@(posedge clk) begin
        if (counter < 1023) counter <= counter + 1;
        else counter <= 0;
    end

    assign slow_clk = (counter = 0) ? 1:0;

endmodule : slow_clock