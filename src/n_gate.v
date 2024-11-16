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
    assign n = n_reg;

    // Compute alpha_m and beta_m based on membrane potential V
    always @(posedge clk) begin
        if (V != -55) begin
            alpha_n = (0.01 * (V + 55)) / (1 - $exp(-(V + 55) / 10));
        end else begin
            alpha_n = 1.0; // Handle singularity at V = -40
        end
        beta_n = 0.125 * $exp(-(V + 65) / 80);

        // Compute the derivative of m
        dn_dt = (alpha_n * (1 - n_reg)) - (beta_n * n_reg);
    end

    // Update m_reg on the rising edge of the clock
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            n_reg <= 0.0; // Reset m to 0 (or another initial value if specified)
        end else begin
            // Update m_reg using the Euler method
            n_reg <= n_reg + dn_dt * dt;

            // Update m to n^4 for equation
            n_reg <= n_reg * n_reg * n_reg * n_reg;
        end
    end
endmodule
