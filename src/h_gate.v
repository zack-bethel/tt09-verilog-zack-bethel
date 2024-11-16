module update_h (
    input real V,       // Membrane potential (in mV)
    input real h,       // Current gating variable value
    input real dt,      // Time step (in ms)
    output real h_next  // Updated gating variable value
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
    end

    // Compute h_next as a wire
    assign h_next = h + dh_dt * dt;

endmodule
