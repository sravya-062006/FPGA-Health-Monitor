`timescale 1ns / 1ps

module health_packet_tx #(
    parameter integer CLK_FREQ  = 100_000_000,
    parameter integer BAUD_RATE = 115200
)(
    input  wire        clk,
    input  wire        reset,

    input  wire [15:0] temperature,
    input  wire [15:0] voltage,
    input  wire [15:0] power,
    input  wire [15:0] error_count,
    input  wire [15:0] health_score,
    input  wire [1:0]  health_state,

    output wire        uart_tx,
    output wire        uart_busy
);

    reg [7:0] uart_data;
    reg       uart_start;

    reg [2:0] byte_index;
    reg       sending;

    /*
        Packet:

        Byte 0 = Temperature
        Byte 1 = Voltage
        Byte 2 = Power
        Byte 3 = Error Count
        Byte 4 = Health Score
        Byte 5 = Health State
    */

    always @(posedge clk) begin

        if (reset) begin

            uart_data  <= 8'd0;
            uart_start <= 1'b0;
            byte_index <= 3'd0;
            sending    <= 1'b0;

        end

        else begin

            uart_start <= 1'b0;

            // Start a new packet
            if (!sending && !uart_busy) begin

                sending    <= 1'b1;
                byte_index <= 3'd0;

            end

            // Send packet bytes
            else if (sending && !uart_busy) begin

                case (byte_index)

                    3'd0:
                        uart_data <= temperature[7:0];

                    3'd1:
                        uart_data <= voltage[7:0];

                    3'd2:
                        uart_data <= power[7:0];

                    3'd3:
                        uart_data <= error_count[7:0];

                    3'd4:
                        uart_data <= health_score[7:0];

                    3'd5:
                        uart_data <= {6'd0, health_state};

                    default:
                        uart_data <= 8'd0;

                endcase

                uart_start <= 1'b1;

                if (byte_index == 3'd5) begin

                    byte_index <= 3'd0;
                    sending    <= 1'b0;

                end

                else begin

                    byte_index <= byte_index + 1'b1;

                end

            end

        end

    end


    // UART transmitter

    uart_tx #(
        .CLK_FREQ(CLK_FREQ),
        .BAUD_RATE(BAUD_RATE)
    ) u_uart_tx (

        .clk(clk),
        .reset(reset),

        .data_in(uart_data),
        .start(uart_start),

        .tx(uart_tx),
        .busy(uart_busy)

    );

endmodule