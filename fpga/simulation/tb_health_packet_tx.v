`timescale 1ns / 1ps

module tb_health_packet_tx;

    reg clk;
    reg reset;

    reg [15:0] temperature;
    reg [15:0] voltage;
    reg [15:0] power;
    reg [15:0] error_count;
    reg [15:0] health_score;
    reg [1:0]  health_state;

    wire uart_tx;
    wire uart_busy;


    health_packet_tx #(
        .CLK_FREQ(100_000_000),
        .BAUD_RATE(115200)
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


    // 100 MHz clock

    always #5 clk = ~clk;


    initial begin

        clk = 1'b0;
        reset = 1'b1;

        temperature = 16'd40;
        voltage = 16'd100;
        power = 16'd200;
        error_count = 16'd0;
        health_score = 16'd100;
        health_state = 2'd0;

        #100;

        reset = 1'b0;


        $display("");
        $display("======================================");
        $display("HEALTH PACKET UART TEST");
        $display("======================================");

        $display("Temperature = %0d", temperature);
        $display("Voltage     = %0d", voltage);
        $display("Power       = %0d", power);
        $display("Errors      = %0d", error_count);
        $display("Health      = %0d", health_score);
        $display("State       = %0d", health_state);


        // Wait for complete packet

        wait(uart_busy == 1'b1);

        $display("UART PACKET TRANSMISSION STARTED");


        wait(uart_busy == 1'b0);

        #100;


        $display("UART PACKET TRANSMISSION COMPLETED");

        $display("======================================");


        #100;

        $finish;

    end

endmodule