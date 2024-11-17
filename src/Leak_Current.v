module leakCurrent (
    input wire          clk,
    input wire          rst,
    input wire signed [15:0] V,  // Current membrane potential (in mV)
    output reg signed [15:0] I_L // Leak current
);

    // Calculate leak current using discretized equation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            I_L <= 16'd0;  // Initial leak current
        end else begin
            //I_L = G_L * (V - E_L)
            I_L <= (16'd3 * ((V * 16'd10) - (-16'd700))) / 16'd10; // Scale V and -70 mV by 10, then divide by 10
        end
    end
endmodule