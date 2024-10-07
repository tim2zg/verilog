`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.08.2024 09:25:19
// Design Name: 
// Module Name: slow_clk
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module slow_clk(
    input clk,         // Input clock (50 MHz)
    output slow_clk    // Output slower clock (500 Hz)
    );
    
    reg [16:0] counter = 0; // 17-bit counter to count up to 99,999 (log2(100,000) = 17)
    
    always @(posedge clk) begin
        if (counter < 99999) 
            counter <= counter + 1;
        else 
            counter <= 0;
    end

    assign slow_clk = (counter == 0) ? 1 : 0; // slow_clk goes high for 1 cycle when counter resets
    
endmodule
