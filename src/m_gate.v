module update_m(
    input wire clk,             // Clock signal
    input wire reset,           // Reset signal
    input wire signed [15:0] V, // Membrane potential (in mV)
    input wire signed [15:0] dt,// Time step (in ms)
    output reg signed [15:0] m_next // Updated gating variable
);

    // Internal variables for calculations
    reg signed [15:0] alpha_m, beta_m, dm_dt;
    reg signed [15:0] m_reg; // Register to store the updated m value

    // Initialize m_reg
    initial begin
        m_reg = 16'd53; // Initial value for m_reg (0.053 scaled by 1000)
    end

    // Assign output to the register value
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            m_reg <= 16'd53; // Reset m to 0.053 for -65mV resting membrane
        end else begin
            if (V != -16'd40) begin
                alpha_m = (16'd10 * (V + 16'd40)) / (16'd1000 - $exp(-(V + 16'd40) / 16'd10));
            end else begin
                alpha_m = 16'd1000; // Handle singularity at V = -40
            end
            beta_m = 16'd4000 * $exp(-(V + 16'd65) / 16'd18);

            // Compute the derivative of m
            dm_dt = (alpha_m * (16'd1000 - m_reg)) - (beta_m * m_reg);

            // Update m_reg using the Euler method
            m_reg <= m_reg + (dm_dt * dt) / 16'd1000;
        end
    end

    // Assign the updated value to the output
    assign m_next = m_reg;
endmodule
