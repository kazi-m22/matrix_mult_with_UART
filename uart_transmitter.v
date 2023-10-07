module uart_transmitter(
    input wire Clock,         // Clock input
    input wire rst,         // Reset input
    output wire TxD,         // UART TX output
//    output wire tx_busy,    // TX busy indicator
    input wire [31:0] data  // 32-bit data to transmit
);

reg [9:0] count;           // Counter for data and stop bits
reg [31:0] data_reg;       // Register for storing the transmitted data
reg tx_start;              // Start transmission flag
wire tx_busy;
assign tx_busy = count != 10'b0; // Indicate TX busy when count is not zero

always @(posedge Clock or posedge rst) begin
    if (rst) begin
        count <= 10'b0;
        data_reg <= 32'b0;
        tx_start <= 1'b0;
    end else if (tx_start) begin
        // Start bit
        if (count == 10'b0) begin
            TxD <= 1'b0;
        end else if (count < 10'd9) begin
            // Transmit data bits (LSB first)
            TxD <= data_reg[count - 1];
        end else begin
            // Stop bit
            TxD <= 1'b1;
        end

        // Increment counter
        if (count < 10'd10) begin
            count <= count + 1'b1;
        end else begin
            count <= 10'b0;
            tx_start <= 1'b0;
        end
    end
end

// Trigger transmission when data is ready
always @(posedge Clock or posedge rst) begin
    if (rst) begin
        // Reset data transmission flag
        tx_start <= 1'b0;
    end else begin
        // Start transmission when data is ready
        if (!tx_start && !tx_busy) begin
            data_reg <= data;
            tx_start <= 1'b1;
        end
    end
end

endmodule