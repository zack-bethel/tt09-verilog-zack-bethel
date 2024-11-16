module LinearHodgkinHuxleyModel (
    input wire clock,                     // Clock input
    input wire reset,                     // Reset input
    input wire [15:0] current_in,          // Multiplexed input for I (current)
    input wire [15:0] dt,               // and dt (time step)
    output reg [15:0] data_out         // Output for membrane potential V
    );

    
    sodiumCurrent NA (.clk(clock), .rst(reset), .V(), .I_NA());
    sodiumCurrent NA (.clk(clock), .rst(reset), .V(), .I_NA());
    sodiumCurrent NA (.clk(clock), .rst(reset), .V(), .I_NA());
    sodiumCurrent NA (.clk(clock), .rst(reset), .V(), .I_NA());

    always @(posedge clk) begin
        

    end

endmodule

