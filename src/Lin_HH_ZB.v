module LinearHodgkinHuxleyModel (
    input wire          clock,          // Clock input
    input wire          reset,          // Reset input
    input wire [7:0]   current_in,     // I (current)
    input wire [7:0]   dt,             // and dt (time step)
    output wire         spike
    );

    reg [15:0] threshold;

    // Internal Wires
    wire [15:0] I_NA, I_K, I_L;
    reg [15:0] V_next, C_M;
    wire [15:0] extended_dt = {8'd0, dt};
    wire async_reset = reset;

    // Currents
    sodiumCurrent NA (.clk(clock), .rst(async_reset), .dt(extended_dt), .V(V_next), .I_NA(I_NA));
    potassiumCurrent K (.clk(clock), .rst(async_reset), .dt(extended_dt), .V(V_next), .I_K(I_K));
    leakCurrent L (.clk(clock), .rst(async_reset), .V(V_next), .I_L(I_L));

    // Calculate next membrane potential using discretized equation
    always @(posedge clock) begin

          C_M <= 1000;
          threshold <= 16'd30;
      if (reset) begin
              V_next <= -65;  // Initial membrane potential
          end else begin
            V_next <= V_next + dt * ({8'd0, current_in} - (I_NA + I_K + I_L)) / C_M;
          end
      end

      //spiking logic
      assign spike = (V_next >= threshold);

endmodule