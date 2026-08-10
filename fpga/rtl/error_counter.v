`timescale 1ns / 1ps

module error_counter(
    input wire clk,
    input wire reset,
    input wire error_event,
    output reg [15:0] error_count
);

    always @(posedge clk) begin
        if (reset)
            error_count <= 16'd0;
        else if (error_event)
            error_count <= error_count + 1'b1;
    end

endmodule