module update_m(
    input wire clk,             // Clock signal
    input wire reset,           // Reset signal
    input wire V,          // Membrane potential (in mV)
    input wire dt,         // Time step (in ms)
    output real n_next          // Updated gating variable (stored in a register)
);

    // Internal variables for calculations
    real alpha_n, beta_n, dn_dt;
    reg real n_reg;        // Register to store the updated m value

    // Assign output to the register value
    assign n_next = n_reg;

    // Compute alpha_n and beta_n based on membrane potential V
    always @(posedge clk) begin
        if (V != -55) begin
            alpha_n = (0.01 * (V + 55)) / (1 - $exp(-(V + 55) / 10));
        end else begin
            alpha_n = 1.0; // Handle singularity at V = -40
        end
        beta_n = 0.125 * $exp(-(V + 65) / 80);

        // Compute the derivative of m
        dn_dt = (alpha_n * (1 - n_reg)) - (beta_n * n_reg);

        if (reset) begin
            n_reg <= 0.002; // Reset m to 0.002 for -65mV resting membrane
        end else begin
            // Update m_reg using the Euler method
            n_reg <= n_reg + dn_dt * dt;
        end
    end
endmodule
