`timescale 1ns / 1ps

module top_module #(
    parameter integer CLOCK_WINDOW = 10,
    parameter integer CLK_FREQ     = 100_000_000,
    parameter integer BAUD_RATE    = 115200
)(
    input  wire        clk,
    input  wire        reset,

    input  wire [15:0] temperature_in,
    input  wire [15:0] voltage_in,
    input  wire [15:0] power_in,
    input  wire        error_event,

    output wire [31:0] clock_count,
    output wire [15:0] temperature,
    output wire [15:0] voltage,
    output wire [15:0] power,
    output wire [15:0] error_count,
    output wire [15:0] health_score,
    output wire [1:0]  health_state,

    output wire        uart_tx,
    output wire        uart_busy
);

    // =====================================================
    // CLOCK MONITOR
    // =====================================================

    clock_monitor #(
        .WINDOW_CYCLES(CLOCK_WINDOW)
    ) u_clock_monitor (
        .clk(clk),
        .reset(reset),
        .clock_count(clock_count)
    );


    // =====================================================
    // TEMPERATURE MONITOR
    // =====================================================

    temperature_monitor u_temperature_monitor (
        .clk(clk),
        .reset(reset),
        .temperature_in(temperature_in),
        .temperature(temperature)
    );


    // =====================================================
    // VOLTAGE MONITOR
    // =====================================================

    voltage_monitor u_voltage_monitor (
        .clk(clk),
        .reset(reset),
        .voltage_in(voltage_in),
        .voltage(voltage)
    );


    // =====================================================
    // POWER MONITOR
    // =====================================================

    power_monitor u_power_monitor (
        .clk(clk),
        .reset(reset),
        .power_in(power_in),
        .power(power)
    );


    // =====================================================
    // ERROR COUNTER
    // =====================================================

    error_counter u_error_counter (
        .clk(clk),
        .reset(reset),
        .error_event(error_event),
        .error_count(error_count)
    );


    // =====================================================
    // HEALTH SCORE
    // =====================================================

    health_monitor u_health_monitor (
        .clk(clk),
        .reset(reset),
        .temperature(temperature),
        .voltage(voltage),
        .power(power),
        .error_count(error_count),
        .health_score(health_score)
    );


    // =====================================================
    // HEALTH FSM
    // =====================================================

    health_fsm u_health_fsm (
        .clk(clk),
        .reset(reset),
        .temperature(temperature),
        .voltage(voltage),
        .power(power),
        .error_count(error_count),
        .state(health_state)
    );


    // =====================================================
    // FULL HEALTH PACKET TRANSMITTER
    // =====================================================

    health_packet_tx_v2 #(
        .CLK_FREQ(CLK_FREQ),
        .BAUD_RATE(BAUD_RATE),
        .PACKET_INTERVAL_MS(10)
    ) u_health_packet_tx (

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

endmodule