module main(
    input clk,
    output motor1,
    output motor2,
    output motor3,
    output motor4
);

    // slow clock
    wire slow_clk;
    slow_clock slow_clock_inst(
        .clk(clk),
        .slow_clk(slow_clk)
    );

    // PWM and PWM decode for motor 1
    wire pwm1_ready;
    wire [31:0] pwm1_value;
    pwm pwm1_inst(
        .clk(clk),
        .freq(100),
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
    wire [31:0] pwm2_value;
    pwm pwm2_inst(
        .clk(clk),
        .freq(100),
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
    wire [31:0] pwm3_value;
    pwm pwm3_inst(
        .clk(clk),
        .freq(100),
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
    wire [31:0] pwm4_value;
    pwm pwm4_inst(
        .clk(clk),
        .freq(100),
        .pwm(motor4)
    );
    pwm_decode pwm4_decode_inst(
        .i_clk(clk), // input clock
        .i_pwm(motor4), // input pwm
        .i_reset(1'b1), // input reset
        .o_pwm_ready(pwm4_ready), // output pwm ready
        .o_pwm_value(pwm4_value) // output pwm value
    );

    // Debug output
    always @(posedge clk) begin
        if (pwm1_ready) $display("Motor 1 PWM Value: %d", pwm1_value);
        if (pwm2_ready) $display("Motor 2 PWM Value: %d", pwm2_value);
        if (pwm3_ready) $display("Motor 3 PWM Value: %d", pwm3_value);
        if (pwm4_ready) $display("Motor 4 PWM Value: %d", pwm4_value);
    end

endmodule : main