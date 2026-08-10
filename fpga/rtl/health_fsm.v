`timescale 1ns / 1ps

module health_fsm(
    input wire clk,
    input wire reset,

    input wire [15:0] temperature,
    input wire [15:0] voltage,
    input wire [15:0] power,
    input wire [15:0] error_count,

    output reg [1:0] state
);

    parameter HEALTHY  = 2'b00;
    parameter WARNING  = 2'b01;
    parameter CRITICAL = 2'b10;

    always @(posedge clk) begin

        if (reset) begin
            state <= HEALTHY;
        end

        else if ((temperature >= 16'd85) ||
                 (voltage < 16'd3000) ||
                 (power >= 16'd5000) ||
                 (error_count >= 16'd20)) begin

            state <= CRITICAL;

        end

        else if ((temperature >= 16'd70) ||
                 (voltage < 16'd3200) ||
                 (power >= 16'd3500) ||
                 (error_count >= 16'd10)) begin

            state <= WARNING;

        end

        else begin
            state <= HEALTHY;
        end

    end

endmodule