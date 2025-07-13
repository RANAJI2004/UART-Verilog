module uart_baud_gen #(
    parameter CLOCK_FREQ = 1536000,   // Adjusted for exact divisor
    parameter BAUD_RATE = 9600
)(
    input wire clk,
    input wire rst,
    output reg baud_tick,
    output reg baud_tick_16x
);

    localparam BAUD_DIVISOR_16X = CLOCK_FREQ / (BAUD_RATE * 16);
    localparam COUNTER_WIDTH = $clog2(BAUD_DIVISOR_16X);

    reg [COUNTER_WIDTH-1:0] counter;
    reg [3:0] oversample_counter;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            oversample_counter <= 0;
            baud_tick <= 0;
            baud_tick_16x <= 0;
        end else begin
            if (counter == BAUD_DIVISOR_16X - 1) begin
                counter <= 0;
                baud_tick_16x <= 1;
                oversample_counter <= oversample_counter + 1;

                if (oversample_counter == 15) begin
                    baud_tick <= 1;
                    oversample_counter <= 0;
                end else begin
                    baud_tick <= 0;
                end
            end else begin
                counter <= counter + 1;
                baud_tick <= 0;
                baud_tick_16x <= 0;
            end
        end
    end

endmodule


