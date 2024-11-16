module update_h (
    input wire V,       // Membrane potential (in mV)
    input wire h,       // Current gating variable value
    input wire dt,      // Time step (in ms)
    output wire h_next  // Updated gating variable value
);

    // Internal variables for alpha_h, beta_h, and dh/dt
    real alpha_h, beta_h, dh_dt;

    // Compute alpha_h and beta_h based on membrane potential V
    always @(posedge clk) begin
        // Calculate alpha_h (floating-point arithmetic)
        alpha_h = 0.07 * $exp(-(V + 65.0) / 20.0);

        // Calculate beta_h (floating-point arithmetic)
        beta_h = 1.0 / (1.0 + $exp(-(V + 35.0) / 10.0));

        // Compute dh/dt: alpha_h * (1 - h) - beta_h * h
        dh_dt = alpha_h * (1.0 - h) - beta_h * h;

        // Compute h_next as a wire
        if (reset) begin
            m_reg <= 0.60; // Reset m to 0.60 for -65mV resting membrane
        end else begin
            // Update h_reg using the Euler method
            assign h_next = h + dh_dt * dt;
        end
    end

endmodule
