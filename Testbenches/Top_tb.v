`timescale 1ns/1ps

module tb_uart_top;

    reg clk;
    reg rst;

    // Transmitter interface
    reg [7:0] tx_data;
    reg tx_start;
    wire tx_serial;
    wire tx_busy;
    wire tx_done;

    // Receiver interface
    wire [7:0] rx_data;
    wire rx_ready;
    wire rx_error;

    // Instantiate the UART top module
    uart_top #(
        .CLOCK_FREQ(1536000),  // Match module parameter for 9600 baud
        .BAUD_RATE(9600)
    ) uut (
        .clk(clk),
        .rst(rst),
        .tx_data(tx_data),
        .tx_start(tx_start),
        .tx_serial(tx_serial),
        .tx_busy(tx_busy),
        .tx_done(tx_done),
        .rx_serial(tx_serial),  // Loopback connection
        .rx_data(rx_data),
        .rx_ready(rx_ready),
        .rx_error(rx_error)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test data array
    reg [7:0] test_data [0:4];
    integer i;

    initial begin
        $dumpfile("uart_top.vcd");
        $dumpvars(0, tb_uart_top);

        // Initialize signals and test data
        rst = 1;
        tx_start = 0;
        tx_data = 8'h00;

        test_data[0] = 8'h24;
        test_data[1] = 8'h81;
        test_data[2] = 8'h09;
        test_data[3] = 8'h63;
        test_data[4] = 8'hFF;

        #1000;
        rst = 0;
        #1000;

        // Test sending multiple bytes
        for (i = 0; i < 5; i = i + 1) begin
            tx_data = test_data[i];
            $display("Sending data: 0x%02X at time %t", tx_data, $time);

            tx_start = 1;
            #20;
            tx_start = 0;

            // Wait for transmission to complete
            wait (tx_done == 1);
            $display("Transmission completed at time %t", $time);

            // Wait for reception or timeout
            receive_or_timeout(test_data[i]);

            // Delay between transmissions
            #5000;
        end

        $display("Complete UART system test completed");
        $finish;
    end

    // Monitor for receiver error
    always @(posedge rx_error) begin
        $display("ERROR: Receiver error detected at time %t", $time);
    end

    // Monitor receiver for debugging
    always @(posedge clk) begin
        if (rx_ready) begin
            $display("RX_READY: Data 0x%02X received at time %t", rx_data, $time);
        end
    end

    // Task to wait for rx_ready or timeout
    task receive_or_timeout;
        input [7:0] expected_data;
        integer timeout_count;
        begin
            timeout_count = 0;
            while (rx_ready !== 1 && timeout_count < 20000) begin
                #1;
                timeout_count = timeout_count + 1;
            end

            if (rx_ready == 1) begin
                if (rx_data == expected_data) begin
                    $display("SUCCESS: Received 0x%02X matches sent data", rx_data);
                end else begin
                    $display("ERROR: Received 0x%02X does not match sent 0x%02X", rx_data, expected_data);
                end
            end 
        end
    endtask

endmodule