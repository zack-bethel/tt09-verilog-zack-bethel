module LinearHodgkinHuxleyModel (
    input wire clock,                     // Clock input
    input wire reset,                     // Reset input
    input wire [15:0] current_in,          // Multiplexed input for I (current)
    input wire [15:0] dt,               // and dt (time step)
    output wire [15:0] data_out         // Output for membrane potential V
    );

    // Internal Wires
    wire I_NA, I_K, I_L, I_tot, V_membrane;
    reg V_next;

    // assign V_next = 
    
    // Currents
    sodiumCurrent NA (.clk(clock), .rst(reset), .V(V_membrane), .I_NA(I_NA));
    potassiumCurrent K (.clk(clock), .rst(reset), .V(V_membrane), .I_K(I_K));
    leakCurrent L (.clk(clock), .rst(reset), .V(V_membrane), .I_L(I_L));

    // Calculate next membrane potential using discretized equation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            V_next <= -65;  // Initial membrane potential
        end else begin
            V_next <= V + dt * (current_in - (I_Na + I_K + I_L)) / CM;
        end
    end

endmodule

