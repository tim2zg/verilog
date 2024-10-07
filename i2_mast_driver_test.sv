module i2c_master_top(
    input wire clock,
    input wire reset_n,
    inout wire external_serial_data,
    inout wire external_serial_clock
);
    // Parameters
    parameter DATA_WIDTH = 8;
    parameter REGISTER_WIDTH = 8;
    parameter ADDRESS_WIDTH = 7;

    localparam REGISTER_ADDRESS_VALUE = 0;
    localparam DATA_VALUE = 1;

    // Internal signals
    reg [6:0] device_address;
    reg [15:0] divider;
    wire [7:0] miso_data;
    wire busy;

    reg enable;
    reg read_write;
    reg [DATA_WIDTH-1:0] mosi_data;
    reg [REGISTER_WIDTH-1:0] register_address;

    reg [DATA_WIDTH-1:0] data_array [0:15];
    integer i;

    // State machine states
    typedef enum logic [3:0] {
        IDLE                = 4'b0000,
        INIT_SETUP          = 4'b0001,
        INIT_WAIT_BUSY_LOW  = 4'b0010,
        INIT_ENABLE         = 4'b0011,
        INIT_WAIT_BUSY_HIGH = 4'b0100,
        INIT_DONE           = 4'b0101,
        CONTINUOUS_READ     = 4'b0110,
        WAIT_READ_BUSY_LOW  = 4'b0111,
        ENABLE_READ         = 4'b1000,  // Ensure a unique value
        WAIT_READ_BUSY_HIGH = 4'b1001   // Ensure a unique value
    } state_t;


    state_t state, next_state;
    reg is_in_initialization;

    // Instantiate the I2C master
    i2c_master #(
        .DATA_WIDTH(DATA_WIDTH),
        .REGISTER_WIDTH(REGISTER_WIDTH),
        .ADDRESS_WIDTH(ADDRESS_WIDTH)
    ) i2c_master_inst (
        .clock(clock),
        .reset_n(reset_n),
        .enable(enable),
        .read_write(read_write),
        .mosi_data(mosi_data),
        .register_address(register_address),
        .device_address(device_address),
        .divider(divider),
        .miso_data(miso_data),
        .busy(busy),
        .external_serial_data(external_serial_data),
        .external_serial_clock(external_serial_clock)
    );

    // Initialize data array and constant values
    initial begin
        data_array[1] = {REGISTER_ADDRESS_VALUE, 7'h6B}; // Register address 0x6B
        data_array[2] = {DATA_VALUE, 7'h80}; // Data value 0x80
        data_array[3] = {REGISTER_ADDRESS_VALUE, 7'h6B}; // Register address 0x6B
        data_array[4] = {DATA_VALUE, 7'h03}; // Data value 0x03
        data_array[5] = {REGISTER_ADDRESS_VALUE, 7'h1A}; // Register address 0x1A
        data_array[6] = {DATA_VALUE, 7'h0};  // Data value 0x0
        data_array[7] = {REGISTER_ADDRESS_VALUE, 7'h1B}; // Register address 0x1B
        data_array[8] = {DATA_VALUE, 7'h18}; // Data value 0x18
        data_array[9] = {REGISTER_ADDRESS_VALUE, 7'h1C}; // Register address 0x1C
        data_array[10] = {DATA_VALUE, 7'h10}; // Data value 0x10

        divider = 30;  // Divider value for 400 kHz
        device_address = 7'h68; // MPU6050 device address 0x68
        is_in_initialization = 1;
        state = IDLE;
        i = 1;
    end

    // State machine to manage the initialization and continuous read processes
    always @(posedge clock or negedge reset_n) begin
        if (!reset_n) begin
            state <= IDLE;
            enable <= 0;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            IDLE: begin
                if (is_in_initialization) begin
                    next_state = INIT_SETUP;
                end else begin
                    next_state = CONTINUOUS_READ;
                end
            end

            INIT_SETUP: begin
                if (i < 11) begin
                    read_write = 0;
                    register_address = data_array[i];
                    mosi_data = data_array[i+1];
                    next_state = INIT_WAIT_BUSY_LOW;
                    $display("INIT_SETUP");
                end else begin
                    next_state = INIT_DONE;
                end
            end

            INIT_WAIT_BUSY_LOW: begin
                if (!busy) begin
                    next_state = INIT_ENABLE;
                end else begin
                    next_state = INIT_WAIT_BUSY_LOW;
                end
            end

            INIT_ENABLE: begin
                enable = 1;
                next_state = INIT_WAIT_BUSY_HIGH;
            end

            INIT_WAIT_BUSY_HIGH: begin
                if (busy) begin
                    enable = 0;
                    next_state = INIT_SETUP;
                    i = i + 2;
                end else begin
                    next_state = INIT_WAIT_BUSY_HIGH;
                end
            end

            INIT_DONE: begin
                is_in_initialization = 0;
                next_state = CONTINUOUS_READ;
            end

            CONTINUOUS_READ: begin
                read_write = 1;  // Set for read operation
                register_address = 7'h43; // Register address 0x43
                next_state = WAIT_READ_BUSY_LOW;
            end

            WAIT_READ_BUSY_LOW: begin
                if (!busy) begin
                    next_state = ENABLE_READ;
                end else begin
                    next_state = WAIT_READ_BUSY_LOW;
                end
            end

            ENABLE_READ: begin
                enable = 1;
                next_state = WAIT_READ_BUSY_HIGH;
            end

            WAIT_READ_BUSY_HIGH: begin
                if (busy) begin
                    enable = 0;
                    next_state = CONTINUOUS_READ;
                    $display("Data: %h", miso_data);
                end else begin
                    next_state = WAIT_READ_BUSY_HIGH;
                end
            end

            default: next_state = IDLE;
        endcase
    end
endmodule
