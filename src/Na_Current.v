module sodiumCurrent (
    input wire          clk,
    input wire          rst,
    input wire [15:0]   V,        // Current membrane potential
    output reg [15:0]   I_NA    // Next membrane potential (feedback output)
    );
    // Internal constants
    reg [15:0] G_NA, E_NA;
    wire m, h;

    update_m m_next (.clk(clk), .reset(rst), V.(V), .dt(), .m(m));
    update_h h_next (.clk(clk), .reset(rst), V.(V), .dt(), .h(h));

    // Calculate next membrane potential using discretized equation
    always @(posedge clk or posedge rst) begin

        // Hodgkin-Huxley constants
        G_NA <= 120.0;
        E_NA <= 50.0;

        if (rst) begin
            I_NA <= 0;  // Initial membrane potential
        end else begin
            I_Na <= G_NA * m * h * (V - E_NA);
        end
    end
endmodule
