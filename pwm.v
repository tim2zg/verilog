`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.08.2024 09:46:47
// Design Name: 
// Module Name: pwm
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


module pwm #(
    parameter DUTY_CYCLE = 128  // Default duty cycle is 50% (128 out of 255)
)(
    input wire clk,              // 50MHz clock input
    output reg pwm          // PWM output signal
);

    // Clock divider: count to 100,000 for 500Hz period
    reg [16:0] counter_500Hz = 0;   // 17-bit counter for 100,000 counts
    reg [16:0] compare_value = 0;   // Scaled compare value for duty cycle

    // Clock divider logic
    always @(posedge clk) begin
        // Increment the clock divider counter
        counter_500Hz <= counter_500Hz + 1;

        // If counter reaches 100,000 (2ms period), reset it
        if (counter_500Hz >= 100000) begin
            counter_500Hz <= 0;
        end
    end

    // Scale the DUTY_CYCLE parameter from 0-255 to match the 100,000 period
    initial begin
        compare_value = (DUTY_CYCLE * 100000) / 255;
    end

    // PWM generation logic
    always @(posedge clk) begin
        // Compare the 500Hz counter with the scaled duty cycle value
        if (counter_500Hz < compare_value) begin
            pwm <= 1;  // High when counter is less than scaled duty cycle
        end else begin
            pwm <= 0;  // Low when counter is greater than or equal to scaled duty cycle
        end
    end

endmodule

