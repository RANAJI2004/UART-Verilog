module uart_tx (
    input wire clk,
    input wire rst,
    input wire baud_tick,
    input wire [7:0] tx_data,
    input wire tx_start,
    output reg tx_serial,
    output reg tx_busy,
    output reg tx_done
);

    localparam IDLE = 3'b000;
    localparam START = 3'b001;
    localparam DATA = 3'b010;
    localparam STOP = 3'b011;
    localparam DONE = 3'b100;

    reg [2:0] state;
    reg [2:0] bit_counter;
    reg [7:0] tx_shift_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            tx_serial <= 1;
            tx_busy <= 0;
            tx_done <= 0;
            bit_counter <= 0;
            tx_shift_reg <= 0;
        end else begin
            case (state)
                IDLE: begin
                    tx_serial <= 1;
                    tx_busy <= 0;
                    tx_done <= 0;
                    if (tx_start) begin
                        tx_shift_reg <= tx_data;
                        tx_busy <= 1;
                        state <= START;
                    end
                end
                START: if (baud_tick) begin
                    tx_serial <= 0;
                    bit_counter <= 0;
                    state <= DATA;
                end
                DATA: if (baud_tick) begin
                    tx_serial <= tx_shift_reg[bit_counter];
                    bit_counter <= bit_counter + 1;
                    if (bit_counter == 7) state <= STOP;
                end
                STOP: if (baud_tick) begin
                    tx_serial <= 1;
                    state <= DONE;
                end
                DONE: if (baud_tick) begin
                    tx_done <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule