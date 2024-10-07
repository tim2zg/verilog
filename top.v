`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.08.2024 09:18:26
// Design Name: 
// Module Name: top
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


module top(
    input wire clk ,//System differential clock
    input wire rst_n ,//system reset
    output wire [1:0] led, //output led
    output wire motor1,
    output wire motor2,
    output wire motor3,
    output wire motor4,
    inout wire external_serial_data,
    inout wire external_serial_clock
    );
    
    led_flash led_flash1(
        .clk(clk),
        .rst_n(rst_n),
        .led(led)
    );
    
    i2c_master_top i2c_master_top(
        .clock(clk),
        .reset_n(rst_n),
        .external_serial_data(external_serial_data),
        .external_serial_clock(external_serial_clock)
    );
    
    // PWM and PWM decode for motor 1
    wire pwm1_ready;
    wire [15:0] pwm1_value;
    pwm #(10) pwm1_inst(
        .clk(clk),
        .pwm(motor1)
    );
    pwm_decode pwm1_decode_inst(
        .i_clk(clk),
        .i_pwm(motor1),
        .i_reset(1'b1),
        .o_pwm_ready(pwm1_ready),
        .o_pwm_value(pwm1_value)
    );

    // PWM and PWM decode for motor 2
    wire pwm2_ready;
    wire [15:0] pwm2_value;
    pwm #(120) pwm2_inst(
        .clk(clk),
        .pwm(motor2)
    );
    pwm_decode pwm2_decode_inst(
        .i_clk(clk),
        .i_pwm(motor2),
        .i_reset(1'b1),
        .o_pwm_ready(pwm2_ready),
        .o_pwm_value(pwm2_value)
    );

    // PWM and PWM decode for motor 3
    wire pwm3_ready;
    wire [15:0] pwm3_value;
    pwm #(150) pwm3_inst(
        .clk(clk),
        .pwm(motor3)
    );
    pwm_decode pwm3_decode_inst(
        .i_clk(clk),
        .i_pwm(motor3),
        .i_reset(1'b1),
        .o_pwm_ready(pwm3_ready),
        .o_pwm_value(pwm3_value)
    );

    // PWM and PWM decode for motor 4
    wire pwm4_ready;
    wire [15:0] pwm4_value;
    pwm #(200) pwm4_inst(
        .clk(clk),
        .pwm(motor4)
    );
    pwm_decode pwm4_decode_inst(
        .i_clk(clk), // input clock
        .i_pwm(motor4), // input pwm
        .i_reset(1'b1), // input reset
        .o_pwm_ready(pwm4_ready), // output pwm ready
        .o_pwm_value(pwm4_value) // output pwm value
    );
    
    // todo is there a need for pwm to bee synchronized with clock?
    // todo add check if signal is betwee 1000 and 2000

    // Registers to store previous values
    reg [15:0] pwm1_values [0:3];
    reg [15:0] pwm2_values [0:3];
    reg [15:0] pwm3_values [0:3];
    reg [15:0] pwm4_values [0:3];

    // Register to store rcDataMean
    reg [15:0] rcDataMean1;
    reg [15:0] rcDataMean2;
    reg [15:0] rcDataMean3;
    reg [15:0] rcDataMean4;

    // Debug output
    always @(posedge clk) begin
        if (pwm1_ready) begin
            pwm1_values[3] <= pwm1_values[2];
            pwm1_values[2] <= pwm1_values[1];
            pwm1_values[1] <= pwm1_values[0];
            pwm1_values[0] <= pwm1_value;
            rcDataMean1 <= (pwm1_values[0] + pwm1_values[1] + pwm1_values[2] + pwm1_values[3]) / 4;
            if (rcDataMean1 <= pwm1_value - 3) begin
                $display("motor 1 plus 2");
            end
            if (rcDataMean1 >= pwm1_value + 3) begin
                $display("motor 1 minus 2");
            end
            $display("Motor 1 Average PWM Value: %d", rcDataMean1);
            $display("Motor 1 PWM Value: %d", pwm1_value);
        end
        if (pwm2_ready) begin
            pwm2_values[3] <= pwm2_values[2];
            pwm2_values[2] <= pwm2_values[1];
            pwm2_values[1] <= pwm2_values[0];
            pwm2_values[0] <= pwm2_value;
            rcDataMean2 <= (pwm2_values[0] + pwm2_values[1] + pwm2_values[2] + pwm2_values[3]) / 4;
            if (rcDataMean2 <= pwm2_value - 3) begin
                $display("motor 2 plus 2");
            end
            if (rcDataMean2 >= pwm2_value + 3) begin
                $display("motor 2 minus 2");
            end
            $display("Motor 2 Average PWM Value: %d", rcDataMean2);
            $display("Motor 2 PWM Value: %d", pwm2_value);
        end
        if (pwm3_ready) begin
            pwm3_values[3] <= pwm3_values[2];
            pwm3_values[2] <= pwm3_values[1];
            pwm3_values[1] <= pwm3_values[0];
            pwm3_values[0] <= pwm3_value;
            pwm3_values[0] <= pwm3_value;
            rcDataMean3 <= (pwm3_values[0] + pwm3_values[1] + pwm3_values[2] + pwm3_values[3]) / 4;
            if (rcDataMean3 <= pwm3_value - 3) begin
                $display("motor 3 plus 2");
            end
            if (rcDataMean3 >= pwm3_value + 3) begin
                $display("motor 3 minus 2");
            end
            $display("Motor 3 Average PWM Value: %d", rcDataMean3);
            $display("Motor 3 PWM Value: %d", pwm3_value);
        end
        if (pwm4_ready) begin
            pwm4_values[3] <= pwm4_values[2];
            pwm4_values[2] <= pwm4_values[1];
            pwm4_values[1] <= pwm4_values[0];
            pwm4_values[0] <= pwm4_value;
            rcDataMean4 <= (pwm4_values[0] + pwm4_values[1] + pwm4_values[2] + pwm4_values[3]);
            if ((rcDataMean4/ 4) <= pwm4_value - 3) begin
                $display("motor 4 plus 2");
            end
            if ((rcDataMean4/ 4) >= pwm4_value + 3) begin
                $display("motor 4 minus 2");
            end
            $display("Motor combined: %d", pwm4_values[0] + pwm4_values[1] + pwm4_values[2] + pwm4_values[3]);
            $display(rcDataMean4);
            $display("Motor 4 Average PWM Value4r: %d", rcDataMean4/ 4);
            $display("Motor 4 PWM Value: %d", pwm4_value);
        end
    end

    ila_0 ila_lol (
        .clk(clk), // input wire clk
    
    
        .probe0(motor1), // input wire [0:0]  probe0  
        .probe1(motor2), // input wire [0:0]  probe1 
        .probe2(motor3), // input wire [0:0]  probe2 
        .probe3(motor4), // input wire [0:0]  probe3 
        .probe4(pwm2_ready), // input wire [15:0]  probe4 
        .probe5(pwm3_ready), // input wire [15:0]  probe5 
        .probe6(pwm1_value), // input wire [15:0]  probe6 
        .probe7(pwm2_value) // input wire [15:0]  probe7
    );
    
endmodule
