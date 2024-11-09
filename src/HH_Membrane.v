module MembranePotential (
    input wire                  clk,
    input wire                  rst,
    input wire [15:0]           I,        // Input current
    input wire [15:0]           m, h, n,  // Gating variables (feedback values)
    input wire [15:0]           dt,       // Time step for integration
    input wire [15:0]           V,        // Current membrane potential
    output reg signed [15:0]    V_next    // Next membrane potential (feedback output)
    );
    // Internal constants
    reg [15:0] I_Na, I_K, I_L, CM, G_NA, G_K, G_L, E_NA, E_K, E_L;

    // Hodgkin-Huxley constants
    CM <= 1.0;
    G_NA <= 120.0;
    G_K <= 36.0;
    G_L <= 0.3;
    E_NA <= 50.0;
    E_K <= -77.0;
    E_L <= -54.4;

    // Calculate ionic currents
    always @(*) begin
        I_Na <= G_NA * m * m * m * h * (V - E_NA);
        I_K <= G_K * n * n * n * n * (V - E_K);
        I_L <= G_L * (V - E_L);
    end

    // Calculate next membrane potential using discretized equation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            V_next <= -65;  // Initial membrane potential
        end else begin
            V_next <= V + dt * (I - (I_Na + I_K + I_L)) / CM;
        end
    end
endmodule