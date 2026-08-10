`timescale 1ns / 1ps

module tb_top_module;

    reg clk;
    reg reset;

    reg [15:0] temperature_in;
    reg [15:0] voltage_in;
    reg [15:0] power_in;
    reg error_event;

    wire [31:0] clock_count;
    wire [15:0] temperature;
    wire [15:0] voltage;
    wire [15:0] power;
    wire [15:0] error_count;
    wire [15:0] health_score;
    wire [1:0]  health_state;

    wire uart_tx;
    wire uart_busy;


    // =====================================================
    // DUT
    // =====================================================

    top_module #(
        .CLOCK_WINDOW(10),
        .CLK_FREQ(100_000_000),
        .BAUD_RATE(115200)
    ) DUT (

        .clk(clk),
        .reset(reset),

        .temperature_in(temperature_in),
        .voltage_in(voltage_in),
        .power_in(power_in),
        .error_event(error_event),

        .clock_count(clock_count),
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
    // TEST SEQUENCE
    // =====================================================

    initial begin

        clk = 1'b0;
        reset = 1'b1;

        temperature_in = 16'd0;
        voltage_in     = 16'd0;
        power_in       = 16'd0;
        error_event    = 1'b0;


        // =================================================
        // RESET
        // =================================================

        #100;

        reset = 1'b0;


        // =================================================
        // TEST 1 - HEALTHY
        // =================================================

        $display("");
        $display("========================================");
        $display("TEST 1 - HEALTHY");
        $display("========================================");

        temperature_in = 16'd40;
        voltage_in     = 16'd3300;
        power_in       = 16'd2000;
        error_event    = 1'b0;

        #100;

        $display("Temperature = %0d C", temperature);
        $display("Voltage     = %0d mV", voltage);
        $display("Power       = %0d mW", power);
        $display("Errors      = %0d", error_count);
        $display("Health      = %0d", health_score);
        $display("State       = %0d", health_state);


        // Wait until packet begins and finishes

        wait(uart_busy == 1'b1);
        wait(uart_busy == 1'b0);


        // =================================================
        // TEST 2 - WARNING
        // =================================================

        $display("");
        $display("========================================");
        $display("TEST 2 - WARNING");
        $display("========================================");

        temperature_in = 16'd72;
        voltage_in     = 16'd3200;
        power_in       = 16'd3500;

        #100;

        $display("Temperature = %0d C", temperature);
        $display("Voltage     = %0d mV", voltage);
        $display("Power       = %0d mW", power);
        $display("Errors      = %0d", error_count);
        $display("Health      = %0d", health_score);
        $display("State       = %0d", health_state);

        wait(uart_busy == 1'b1);
        wait(uart_busy == 1'b0);


        // =================================================
        // TEST 3 - ERROR EVENTS
        // =================================================

        $display("");
        $display("========================================");
        $display("TEST 3 - ERROR EVENTS");
        $display("========================================");

        error_event = 1'b1;
        #10;

        error_event = 1'b0;
        #10;

        error_event = 1'b1;
        #10;

        error_event = 1'b0;
        #10;

        error_event = 1'b1;
        #10;

        error_event = 1'b0;

        #100;

        $display("Temperature = %0d C", temperature);
        $display("Voltage     = %0d mV", voltage);
        $display("Power       = %0d mW", power);
        $display("Errors      = %0d", error_count);
        $display("Health      = %0d", health_score);
        $display("State       = %0d", health_state);

        wait(uart_busy == 1'b1);
        wait(uart_busy == 1'b0);


        // =================================================
        // TEST 4 - CRITICAL
        // =================================================

        $display("");
        $display("========================================");
        $display("TEST 4 - CRITICAL");
        $display("========================================");

        temperature_in = 16'd90;
        voltage_in     = 16'd2900;
        power_in       = 16'd6000;

        #100;

        $display("Temperature = %0d C", temperature);
        $display("Voltage     = %0d mV", voltage);
        $display("Power       = %0d mW", power);
        $display("Errors      = %0d", error_count);
        $display("Health      = %0d", health_score);
        $display("State       = %0d", health_state);

        wait(uart_busy == 1'b1);
        wait(uart_busy == 1'b0);


        // =================================================
        // COMPLETE
        // =================================================

        #1000;

        $display("");
        $display("========================================");
        $display("INTEGRATED HEALTH PACKET TEST COMPLETE");
        $display("========================================");

        $finish;

    end

endmodule