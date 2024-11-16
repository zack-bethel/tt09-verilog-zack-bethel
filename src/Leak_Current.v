module leakCurrent (
    input wire          clk,
    input wire          rst,
    input wire [15:0]   V,        // Current membrane potential
    output reg [15:0]   I_L    // Next membrane potential (feedback output)
    );
    // Internal constants
    reg [15:0] G_L, E_L;
    
    // Calculate next membrane potential using discretized equation
    always @(posedge clk || posedge rst) begin

        // Hodgkin-Huxley constants
        G_L <= 0.3;
        E_L <= -70;

        if (rst) begin
            I_L <= 0;  // Initial membrane potential
        end else begin
            I_Na <= G_L * (V - E_L);
        end
    end
endmodule
