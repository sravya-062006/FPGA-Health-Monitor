`timescale 1ns / 1ps

module health_monitor(
    input wire clk,
    input wire reset,

    input wire [15:0] temperature,
    input wire [15:0] voltage,
    input wire [15:0] power,
    input wire [15:0] error_count,

    output reg [15:0] health_score
);

    always @(posedge clk) begin

        if (reset) begin
            health_score <= 16'd100;
        end

        else if ((temperature >= 16'd85) ||
                 (voltage < 16'd3000) ||
                 (power >= 16'd5000) ||
                 (error_count >= 16'd20)) begin

            health_score <= 16'd50;

        end

        else if ((temperature >= 16'd70) ||
                 (voltage < 16'd3200) ||
                 (power >= 16'd3500) ||
                 (error_count >= 16'd10)) begin

            health_score <= 16'd75;

        end

        else begin

            health_score <= 16'd100;

        end

    end

endmodule