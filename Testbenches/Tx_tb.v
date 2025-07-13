module tb_uart_tx;

    reg clk;
    reg rst;
    reg baud_tick;
    reg [7:0] tx_data;
    reg tx_start;
    wire tx_serial;
    wire tx_busy;
    wire tx_done;
    
    // Instantiate the module
    uart_tx uut (
        .clk(clk),
        .rst(rst),
        .baud_tick(baud_tick),
        .tx_data(tx_data),
        .tx_start(tx_start),
        .tx_serial(tx_serial),
        .tx_busy(tx_busy),
        .tx_done(tx_done)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Baud tick generation (simplified for testing)
    initial begin
        baud_tick = 0;
        forever #520 baud_tick = ~baud_tick;  // Approximately 9600 baud
    end
    
    // Test sequence
    initial begin
        $dumpfile("uart_tx.vcd");
        $dumpvars(0, tb_uart_tx);
        
        rst = 1;
        tx_start = 0;
        tx_data = 8'h00;
        #100;
        rst = 0;
        #100;
        
        // Test transmitting 'A' (0x41)
        tx_data = 8'h41;
        tx_start = 1;
        #10;
        tx_start = 0;
        
        // Wait for transmission to complete
        @(posedge tx_done);
        $display("Transmission of 0x41 completed at time %t", $time);
        
        #1000;
        
        // Test transmitting 'B' (0x42)
        tx_data = 8'h42;
        tx_start = 1;
        #10;
        tx_start = 0;
        
        @(posedge tx_done);
        $display("Transmission of 0x42 completed at time %t", $time);
        
        #1000;
        $display("UART transmitter test completed");
        $finish;
    end
    
endmodule