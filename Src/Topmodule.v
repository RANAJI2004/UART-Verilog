module uart_top #(
    parameter CLOCK_FREQ = 1536000,
    parameter BAUD_RATE = 9600
)(
    input wire clk,
    input wire rst,

    input wire [7:0] tx_data,
    input wire tx_start,
    output wire tx_serial,
    output wire tx_busy,
    output wire tx_done,

    input wire rx_serial,
    output wire [7:0] rx_data,
    output wire rx_ready,
    output wire rx_error
);

    wire baud_tick;
    wire baud_tick_16x;

    uart_baud_gen #(
        .CLOCK_FREQ(CLOCK_FREQ),
        .BAUD_RATE(BAUD_RATE)
    ) baud_gen_inst (
        .clk(clk),
        .rst(rst),
        .baud_tick(baud_tick),
        .baud_tick_16x(baud_tick_16x)
    );

    uart_tx tx_inst (
        .clk(clk),
        .rst(rst),
        .baud_tick(baud_tick),
        .tx_data(tx_data),
        .tx_start(tx_start),
        .tx_serial(tx_serial),
        .tx_busy(tx_busy),
        .tx_done(tx_done)
    );

    uart_rx rx_inst (
        .clk(clk),
        .rst(rst),
        .baud_tick_16x(baud_tick_16x),
        .rx_serial(rx_serial),
        .rx_data(rx_data),
        .rx_ready(rx_ready),
        .rx_error(rx_error)
    );

endmodule
