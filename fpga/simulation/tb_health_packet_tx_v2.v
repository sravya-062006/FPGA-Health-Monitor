`timescale 1ns / 1ps

module tb_health_packet_tx_v2;

    reg clk;
    reg reset;

    reg [15:0] temperature;
    reg [15:0] voltage;
    reg [15:0] power;
    reg [15:0] error_count;
    reg [15:0] health_score;
    reg [1:0] health_state;

    wire uart_tx;
    wire uart_busy;


    // =====================================================
    // DUT
    // =====================================================

    health_packet_tx_v2 #(
        .CLK_FREQ(100_000_000),
        .BAUD_RATE(115200),
        .PACKET_INTERVAL_MS(1)
    ) DUT (

        .clk(clk),
        .reset(reset),

        .temperature(temperature),
        .voltage(voltage),
        .power(power),
        .error_count(error_count),
        .health_score(health_score),
        .health_state(health_state),

        .uart_tx(uart_tx),
        .uart_busy(uart_busy)
    );


    // =====================================================
    // 100 MHz CLOCK
    // =====================================================

    always #5 clk = ~clk;


    // =====================================================
    // TEST
    // =====================================================

    initial begin

        clk = 1'b0;
        reset = 1'b1;

        temperature = 16'd40;
        voltage = 16'd3300;
        power = 16'd2000;
        error_count = 16'd3;
        health_score = 16'd75;
        health_state = 2'd1;


        // Reset
        #100;

        reset = 1'b0;


        $display("");
        $display("========================================");
        $display("FULL HEALTH PACKET UART TEST");
        $display("========================================");

        $display("Temperature = %0d C", temperature);
        $display("Voltage     = %0d mV", voltage);
        $display("Power       = %0d mW", power);
        $display("Errors      = %0d", error_count);
        $display("Health      = %0d", health_score);
        $display("State       = %0d", health_state);


        // Wait for packet transmission
        wait(uart_busy == 1'b1);

        $display("UART PACKET STARTED");


        wait(uart_busy == 1'b0);

        $display("UART PACKET COMPLETED");


        #2000;


        $display("");
        $display("========================================");
        $display("FULL PACKET TEST COMPLETED");
        $display("========================================");

        $finish;

    end

endmodule