`timescale 1ns / 1ps

module temperature_monitor(
    input wire clk,
    input wire reset,
    input wire [15:0] temperature_in,
    output reg [15:0] temperature
);

    always @(posedge clk) begin
        if (reset)
            temperature <= 16'd0;
        else
            temperature <= temperature_in;
    end

endmodule