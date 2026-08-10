`timescale 1ns / 1ps

module voltage_monitor(
    input wire clk,
    input wire reset,
    input wire [15:0] voltage_in,
    output reg [15:0] voltage
);

    always @(posedge clk) begin
        if (reset)
            voltage <= 16'd0;
        else
            voltage <= voltage_in;
    end

endmodule