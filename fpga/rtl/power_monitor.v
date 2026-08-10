`timescale 1ns / 1ps

module power_monitor(
    input wire clk,
    input wire reset,
    input wire [15:0] power_in,
    output reg [15:0] power
);

    always @(posedge clk) begin
        if (reset)
            power <= 16'd0;
        else
            power <= power_in;
    end

endmodule