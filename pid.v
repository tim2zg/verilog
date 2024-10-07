module pid;
    real kp = 0.6;
    real ki = 5.0;
    real kd = 0.0001;

    real setpoint = 100.0;
    real last_time = 0.0;

    real mesured_value = 0.0;
    real last_error = 0.0;

    integer l = 0; // for loop

    // tmp for loop
    real tmp_delta_time = 0.0;
    real tmp_delta_error = 0.0;

    initial begin
        for (l = 0; l < 100; l = l + 1) begin
            $display("i: %d", l);

            tmp_delta_time = l * 0.1 - last_time;

            if (tmp_delta_time > 0) begin
                tmp_delta_error = ((setpoint - mesured_value) - last_error);
                if (last_error == 0) begin
                    tmp_delta_error = 0.0;
                end

                last_error = (setpoint - mesured_value);
                last_time = l * 0.1;
                mesured_value = mesured_value + ((kp * (setpoint - mesured_value)) + (ki * (setpoint - mesured_value) * tmp_delta_time) + (kd * (tmp_delta_error / tmp_delta_time)));
                $display("mesured_value: %f", mesured_value);
            end
        end
    end

endmodule
