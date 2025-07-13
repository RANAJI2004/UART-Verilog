module tb_uart_baud_gen;

    reg clk;
    reg rst;
    wire baud_tick;
    wire baud_tick_16x;
    
    // Instantiate the module
    uart_baud_gen #(
        .CLOCK_FREQ(1000000),  // 1MHz for faster simulation
        .BAUD_RATE(9600)
    ) uut (
        .clk(clk),
        .rst(rst),
        .baud_tick(baud_tick),
        .baud_tick_16x(baud_tick_16x)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 100MHz clock
    end
    
    // Test sequence
    initial begin
        $dumpfile("uart_baud_gen.vcd");
        $dumpvars(0, tb_uart_baud_gen);
        
        rst = 1;
        #100;
        rst = 0;
        
        // Wait for several baud ticks
        repeat(10) begin
            @(posedge baud_tick);
            $display("Baud tick at time %t", $time);
        end
        
        $display("Baud rate generator test completed");
        $finish;
    end
    
endmodule