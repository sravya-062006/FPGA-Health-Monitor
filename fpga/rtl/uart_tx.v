`timescale 1ns / 1ps

module uart_tx #(
    parameter integer CLK_FREQ  = 100_000_000,
    parameter integer BAUD_RATE = 115200
)(
    input  wire       clk,
    input  wire       reset,

    input  wire [7:0] data_in,
    input  wire       start,

    output reg        tx,
    output reg        busy
);

    // Number of FPGA clock cycles required for one UART bit
    localparam integer CLKS_PER_BIT = CLK_FREQ / BAUD_RATE;

    reg [31:0] clock_count;
    reg [3:0]  bit_index;
    reg [9:0]  tx_shift;

    always @(posedge clk) begin

        if (reset) begin

            tx          <= 1'b1;
            busy        <= 1'b0;
            clock_count <= 32'd0;
            bit_index   <= 4'd0;
            tx_shift    <= 10'b1111111111;

        end

        else begin

            // UART is idle
            if (!busy) begin

                tx <= 1'b1;

                // Start transmission
                if (start) begin

                    /*
                       UART frame:

                       Bit 0  = Start bit
                       Bit 1-8 = Data bits
                       Bit 9  = Stop bit

                       Example:
                       data_in = 8'h48 = 'H'
                    */

                    tx_shift <= {1'b1, data_in, 1'b0};

                    busy        <= 1'b1;
                    clock_count <= 32'd0;
                    bit_index   <= 4'd0;

                    // Start bit
                    tx <= 1'b0;

                end
            end

            // UART is transmitting
            else begin

                if (clock_count == CLKS_PER_BIT - 1) begin

                    clock_count <= 32'd0;

                    if (bit_index == 4'd9) begin

                        // Transmission completed
                        busy      <= 1'b0;
                        tx        <= 1'b1;
                        bit_index <= 4'd0;

                    end

                    else begin

                        bit_index <= bit_index + 1'b1;

                        tx <= tx_shift[bit_index + 1'b1];

                    end

                end

                else begin

                    clock_count <= clock_count + 1'b1;

                end

            end
        end

    end

endmodule