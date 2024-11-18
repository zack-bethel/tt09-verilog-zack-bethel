module update_h (
    input wire clk,             // Clock signal
    input wire reset,           // Reset signal
    input wire signed [15:0] V, // Membrane potential (in mV)
    input wire signed [15:0] dt,// Time step (in ms)
    output reg signed [15:0] h_next // Updated gating variable value
);

    // Internal variables for alpha_h, beta_h, and dh/dt
    reg signed [15:0] alpha_h, beta_h, dh_dt;
    reg signed [15:0] h_reg; // Register to store the updated h value

    // Initialize h_reg
    initial begin
        h_reg = 16'd600; // Initial value for h_reg (0.60 scaled by 1000)
    end

    // Compute alpha_h and beta_h based on membrane potential V
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            h_reg <= 16'd600; // Reset h to 0.60 for -65mV resting membrane (scaled by 1000)
        end else begin
            // Calculate alpha_h (fixed-point arithmetic)
            alpha_h = (16'd70 * 2^(-(V + 16'd65) / 16'd20)) / 16'd1000;

            // Calculate beta_h (fixed-point arithmetic)
            beta_h = 16'd1000 / (16'd1000 + 2^(-(V + 16'd35) / 16'd10));

            // Compute dh/dt: alpha_h * (1000 - h_reg) - beta_h * h_reg
            dh_dt = (alpha_h * (16'd1000 - h_reg)) - (beta_h * h_reg);

            // Update h_reg using the Euler method
            h_reg <= h_reg + (dh_dt * dt) / 16'd1000;
        end
    end

    // Assign the updated value to the output
    assign h_next = h_reg;
endmodule