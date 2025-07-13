module uart_rx (
    input wire clk,
    input wire rst,
    input wire baud_tick_16x,
    input wire rx_serial,
    output reg [7:0] rx_data,
    output reg rx_ready,
    output reg rx_error
);

    localparam IDLE = 3'b000;
    localparam START = 3'b001;
    localparam DATA = 3'b010;
    localparam STOP = 3'b011;

    reg [2:0] state;
    reg [2:0] bit_counter;
    reg [7:0] rx_shift_reg;
    reg [3:0] sample_counter;
    reg [2:0] rx_sync;
    reg prev_rx_filtered;
    reg [1:0] rx_ready_hold;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rx_sync <= 3'b111;
            prev_rx_filtered <= 1;
            rx_ready <= 0;
            rx_ready_hold <= 0;
        end else begin
            rx_sync <= {rx_sync[1:0], rx_serial};
            prev_rx_filtered <= rx_sync[2];

            if (rx_ready_hold > 0) begin
                rx_ready_hold <= rx_ready_hold - 1;
                rx_ready <= 1;
            end else begin
                rx_ready <= 0;
            end
        end
    end

    wire rx_filtered = rx_sync[2];
    wire start_bit_detected = prev_rx_filtered & ~rx_filtered;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            rx_error <= 0;
            bit_counter <= 0;
            sample_counter <= 0;
            rx_shift_reg <= 0;
        end else begin
            if (rx_error) rx_error <= 0;

            case (state)
                IDLE: begin
                    if (start_bit_detected) begin
                        state <= START;
                        sample_counter <= 0;
                    end
                end
                START: if (baud_tick_16x) begin
                    sample_counter <= sample_counter + 1;
                    if (sample_counter == 7) begin
                        if (rx_filtered == 0) begin
                            state <= DATA;
                            bit_counter <= 0;
                            sample_counter <= 0;
                        end else begin
                            rx_error <= 1;
                            state <= IDLE;
                        end
                    end
                end
                DATA: if (baud_tick_16x) begin
                    sample_counter <= sample_counter + 1;
                    if (sample_counter == 15) begin
                        rx_shift_reg[bit_counter] <= rx_filtered;
                        bit_counter <= bit_counter + 1;
                        sample_counter <= 0;
                        if (bit_counter == 7) state <= STOP;
                    end
                end
                STOP: if (baud_tick_16x) begin
                    sample_counter <= sample_counter + 1;
                    if (sample_counter == 15) begin
                        if (rx_filtered == 1) begin
                            rx_data <= rx_shift_reg;
                            rx_ready_hold <= 2;
                        end else begin
                            rx_error <= 1;
                        end
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule
