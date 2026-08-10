`timescale 1ns / 1ps

module clock_monitor #(
    parameter integer WINDOW_CYCLES = 10
)(
    input wire clk,
    input wire reset,
    output reg [31:0] clock_count
);

    reg [31:0] window_count;

    always @(posedge clk) begin
        if (reset) begin
            window_count <= 32'd0;
            clock_count  <= 32'd0;
        end
        else begin
            if (window_count == WINDOW_CYCLES - 1) begin
                clock_count  <= window_count;
                window_count <= 32'd0;
            end
            else begin
                window_count <= window_count + 1'b1;
            end
        end
    end

endmodule