module update_n(
    input wire clk,             // Clock signal
    input wire reset,           // Reset signal
    input wire signed [15:0] V, // Membrane potential (in mV)
    input wire signed [15:0] dt,// Time step (in ms)
    output reg signed [15:0] n_next // Updated gating variable
);

    // Internal variables for calculations
    reg signed [15:0] alpha_n, beta_n, dn_dt;
    reg signed [15:0] n_reg; // Register to store the updated n value

    // Initialize n_reg
    initial begin
        n_reg = 16'd2; // Initial value for n_reg (0.002 scaled by 1000)
    end

    // Assign output to the register value
    always @(posedge clk or posedge reset) begin

        //Check for reset very first!
        if (reset) begin
            n_reg <= 16'd2; // Reset n to 0.002 for -65mV resting membrane
        end else begin

            //else, calculate alpha_n!
            //sepcial case when V= -55mV then we divide by 0
            if (V != -16'd55) begin
                alpha_n = (16'd10 * (V + 16'd55)) / (16'd1000 - $exp(-(V + 16'd55) / 16'd10));
            end else begin
                alpha_n = 16'd1000; // Handle singularity at V = -55
            end

            // Calculate Beta_n!
            beta_n = 16'd125 * $exp(-(V + 16'd65) / 16'd80);

            // Compute the derivative of n
            dn_dt = (alpha_n * (16'd1000 - n_reg)) - (beta_n * n_reg);

            // Update n_reg using the Euler method
            n_reg <= n_reg + (dn_dt * dt) / 16'd1000;
        end
    end

    // Assign the updated value to the output
    assign n_next = n_reg;
endmodule