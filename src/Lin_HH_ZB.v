module LinearHodgkinHuxleyModel (
    input wire clock,                     // Clock input
    input wire reset,                     // Reset input
    input wire [15:0] current_in,          // Multiplexed input for I (current)
    input wire [15:0] dt,               // and dt (time step)
    output reg [15:0] data_out         // Output for membrane potential V
);

    // Internal variables
    reg [1:0]           state, next_state;
    reg signed [15:0]   V, V_next;      // Membrane potential with feedback
    reg [15:0]          m, m_next;      // Sodium gating variable with feedback
    reg [15:0]          h, h_next;      // Potassium gating variable with feedback
    reg [15:0]          n, n_next;      // Leak gating variable with feedback

    // FSM States
    parameter STATE_INIT = 2'b00;
    parameter STATE_READ = 2'b01;
    parameter STATE_CALCULATE_V = 2'b10;
    parameter STATE_OUTPUT_V = 2'b11;

    state = STATE_INIT;

    always @(posedge clk) begin
        if (reset || state == STATE_INIT) begin
            V <= -65;            // Initial membrane potential
            m <= 0;
            h <= 1;
            n <= 0;
            state <= STATE_READ;
        end 
        else begin
            if (state == STATE_READ) begin
                // Update the feedback values
                // Membrane Potential Calculation (using gating variables with feedback)
                MembranePotential mem_pot (.clk(clock),
                                            .rst(reset),
                                            .I(current_in),
                                            .m(m),
                                            .h(h),
                                            .n(n),
                                            .dt(dt),
                                            .V(V),
                                            .V_next(V_next));
                V <= V_next;

                // Gating Variables Calculation (with feedback)
                GatingVariable m_gate ( .clk(clock),
                                        .rst(reset),
                                        .V(V), 
                                        .g_value(m), 
                                        .g_next(m_next), 
                                        .A0(0.1), 
                                        .B0(4.0));
                m <= m_next;

                GatingVariable h_gate ( .clk(clock), 
                                        .rst(reset), 
                                        .V(V), 
                                        .g_value(h), 
                                        .g_next(h_next), 
                                        .A0(0.07), 
                                        .B0(1.0));
                h <= h_next;

                GatingVariable n_gate ( .clk(clock),
                                        .rst(reset), 
                                        .V(V), 
                                        .g_value(n), 
                                        .g_next(n_next), 
                                        .A0(0.01), 
                                        .B0(0.125));
                n <= n_next;

                state <= STATE_OUTPUT_V;
            end             
        end
        if (state == STATE_OUTPUT_V) begin
            assign data_out = V;  // Output the calculated membrane potential
            state <= STATE_READ;
        end
    end

endmodule

