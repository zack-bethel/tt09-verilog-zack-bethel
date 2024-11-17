module LinearHodgkinHuxleyModel (
    input wire          clock,          // Clock input
    input wire          reset,          // Reset input
    input wire [15:0]   current_in,     // Multiplexed input for I (current)
    input wire [15:0]   dt,             // and dt (time step)
    output wire         spike
    );

    reg [7:0] threshold;

    // Internal Wires
    wire I_NA, I_K, I_L, I_tot, V_membrane, dt_time;
    reg V_next, C_M;

  	assign dt_time = dt;
    // Currents
    sodiumCurrent NA (.clk(clock), .rst(reset), .dt(dt), .V(V_membrane), .I_NA(I_NA));
    potassiumCurrent K (.clk(clock), .rst(reset), .dt(dt), .V(V_membrane), .I_K(I_K));
    leakCurrent L (.clk(clock), .rst(reset), .V(V_membrane), .I_L(I_L));

    // Calculate next membrane potential using discretized equation
  always @(posedge clock) begin

        C_M <= 1e-6;
        threshold <= 16'd30;
    if (reset) begin
            V_next <= -65;  // Initial membrane potential
        end else begin
          V_next <= V_next + dt * (current_in - (I_NA + I_K + I_L)) / C_M;
        end
    end

    //spiking logic
    assign spike = (V_next >= threshold);

endmodule