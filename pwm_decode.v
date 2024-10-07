`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.08.2024 19:44:13
// Design Name: 
// Module Name: pwm_decode
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


module pwm_decode #(
    parameter clockFreq = 50000000)
    (input wire i_clk, // input clock
        input wire i_pwm, // input pwm
        input wire i_reset, // input reset
        output wire  o_pwm_ready, // output pwm ready
        output reg [15:0] o_pwm_value); // output pwm value

    // setups register for pwm decode

    reg [15:0] pwm_on_count;
    reg [15:0] pwm_off_count;
    reg pwm_ready;
    reg [1:0] state;
    reg [15:0] clk_counter;
    reg [1:0] pwm_sig;

    // setups parameters for pwm decode

    localparam CLK_DIVIDER = (clockFreq / 1000000) -1;
    localparam GUARD_ERROR 	= 16'h8000;

    // setups clock states for pwm decode and error states

    localparam MEASURING_ON = 2'b1;
    localparam MEASURING_OFF = 2'b0;
    localparam MEASURE_COMPLETE = 2'b10;

    // setups error states for pwm decode

    localparam NO_ERROR = 16'h0;
    localparam GUARD_TIME_ON_MAX = 16'd2600;
    localparam GUARD_TIME_ON_MIN = 16'd800;
    localparam GUARD_TIME_OFF_MAX = 16'd20000;

    // setups pwm decode states

    initial begin
        pwm_ready = 0;
        state = MEASURING_OFF;
        clk_counter =0;
        pwm_on_count = 0;
        pwm_off_count = 0;
        pwm_sig = 0;
        o_pwm_value = 0;
    end

    // assign pwm ready to pwm_ready

    assign o_pwm_ready = pwm_ready;

    // pwm decode logic

    always @(posedge i_clk or negedge i_reset) begin

        if (!i_reset) begin // reset when restet is triggered
            pwm_ready <= 0;
            state <= MEASURING_OFF;
            clk_counter <= 0;
            pwm_on_count <= 0;
            pwm_off_count <= 0;
            pwm_sig <= 0;
            o_pwm_value <= 0;
        end
        else begin
            //synchronize FF
            pwm_sig = {pwm_sig[0], i_pwm};


            // pwm decode state machine
            case (state)

                // measure off
                MEASURING_OFF: begin
                    // this is the measure off state for the pwm decode by using the clock counter and the pwm off count
                    if (pwm_sig[1] == 0) begin // measure off state for the pwm decode
                        if (clk_counter < CLK_DIVIDER ) // check if the clock counter is less then the clock divider
                            clk_counter <= clk_counter + 1'b1; // increment the clock counter by 1
                        else begin // else if the clock counter is greater then the clock divider
                            clk_counter <= 0; // reset the clock counter
                            if (pwm_off_count < GUARD_TIME_OFF_MAX) // check if the pwm off count is less then the guard time off max
                                pwm_off_count <= pwm_off_count + 1'b1; // increment the pwm off count by 1
                            else begin // else if the pwm off count is greater then the guard time off max
                                /* use pwm_off_count greater then 26ms, notify pwm*/
                                o_pwm_value <= GUARD_ERROR; // set the pwm value to the guard error
                                pwm_ready <= 1; // set the pwm ready to 1
                                state <= MEASURE_COMPLETE; // set the state to measure complete
                            end
                        end
                    end
                    else begin // measure on state for the pwm decode
                        pwm_on_count <= 0; // set the pwm on count to 0
                        pwm_off_count <= 0; // set the pwm off count to 0
                        pwm_ready <= 0; // set the pwm ready to 0
                        state <= MEASURING_ON; // set the state to measure on
                        clk_counter <= 0; // reset the clock counter
                    end
                end

                MEASURING_ON: begin /* measure on */
                    // this is the measure on state for the pwm decode by using the clock counter and the pwm on count
                    if (pwm_sig[1]) begin // measure on state for the pwm decode
                        // check if the clock counter is less then the clock divider
                        if (clk_counter < CLK_DIVIDER )
                            clk_counter <= clk_counter + 1'b1; // increment the clock counter by 1
                        else begin // else if the clock counter is greater then the clock divider
                            clk_counter <= 0; // reset the clock counter
                            if (pwm_on_count < GUARD_TIME_ON_MAX) // check if the pwm on count is less then the guard time on max
                                pwm_on_count <= pwm_on_count + 1'b1; // increment the pwm on count by 1
                            else begin // else if the pwm on count is greater then the guard time on max
                                state <= MEASURE_COMPLETE; // set the state to measure complete
                                o_pwm_value <= pwm_on_count | GUARD_ERROR; // set the pwm value to the pwm on count or the guard error
                                pwm_ready <= 1; // set the pwm ready to 1
                            end
                        end
                    end
                    else begin // measure off state for the pwm decode
                        if ( pwm_on_count < GUARD_TIME_ON_MIN) // check if the pwm on count is less then the guard time on min
                            pwm_on_count <= pwm_on_count | GUARD_ERROR; // set the pwm on count to the pwm on count or the guard error

                        pwm_ready <= 1; // set the pwm ready to 1
                        state <= MEASURE_COMPLETE; // set the state to measure complete
                        o_pwm_value <= pwm_on_count; // set the pwm value to the pwm on count
                    end
                end

                MEASURE_COMPLETE: begin /* restart measurement */ // restart measurement for the pwm decode
                    clk_counter <= 0; // reset the clock counter
                    pwm_ready <= 0; // set the pwm ready to 0
                    state <= MEASURING_OFF; // set the state to measure off
                    pwm_on_count <=0; // set the pwm on count to 0
                    pwm_off_count <= 0; // set the pwm off count to 0
                end

            endcase
        end

    end


endmodule
