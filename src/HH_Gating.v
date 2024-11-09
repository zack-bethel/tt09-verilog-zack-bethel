module GatingVariable (
    input wire clk,
    input wire rst,
    input wire [15:0] V,        // Membrane potential (feedback)
    input wire [15:0] g_value,  // Current gating variable value
    output reg [15:0] g_next,   // Next gating variable value
    parameter real A0 = 0.0,    // Parameter for alpha calculation
    parameter real B0 = 0.0     // Parameter for beta calculation
    );
    reg [15:0] alpha, beta;

    // Update gating variable using discrete differential equation
    always @(posedge clk or posedge rst) begin
        // Calculate alpha and beta based on gating variable equations
        alpha <= A0 * (V + 10) / (1 - exp(-(V + 10) / 10));
        beta <= B0 * exp(-(V + 10) / 10);

        if (rst) begin
            g_next <= 0;
        end else begin
            g_next <= g_value + (alpha * (1 - g_value) - beta * g_value);
        end
    end
endmodule
