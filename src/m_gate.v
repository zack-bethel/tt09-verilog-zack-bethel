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
    assign m = m_reg;

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
    end

    // Update m_reg on the rising edge of the clock
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            m_reg <= 0.0; // Reset m to 0 (or another initial value if specified)
        end else begin
            // Update m_reg using the Euler method
            m_reg <= m_reg + dm_dt * dt;

            // Update m to m^3 for equation
            m_reg <= m_reg * m_reg *m_reg;
        end
    end
endmodule
