module update_m(
    input wire clk,             // Clock signal
    input wire reset,           // Reset signal
    input wire V,          // Membrane potential (in mV)
    input wire dt,         // Time step (in ms)
    output real m_next          // Updated gating variable (stored in a register)
);

    // Internal variables for calculations
    real alpha_m, beta_m, dm_dt;
    reg real m_reg;        // Register to store the updated m value

    // Assign output to the register value
    assign m_next = m_reg;

    // Compute alpha_m and beta_m based on membrane potential V
    always @(posedge clk) begin
        if (V != -40) begin
            alpha_m = (0.1 * (V + 40)) / (1 - $exp(-(V + 40) / 10));
        end else begin
            alpha_m = 1.0; // Handle singularity at V = -40
        end
        beta_m = 4.0 * $exp(-(V + 65) / 18);

        // Compute the derivative of m
        dm_dt = (alpha_m * (1 - m_reg)) - (beta_m * m_reg);
    
        if (reset) begin
            m_reg <= 0.053; // Reset m to 0.053 for -65mV resting membrane
        end else begin
            // Update m_reg using the Euler method
            m_reg <= m_reg + (dm_dt * dt);
        end
    end
endmodule
