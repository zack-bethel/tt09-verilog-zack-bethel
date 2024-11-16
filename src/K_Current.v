module sodiumCurrent (
    input wire          clk,
    input wire          rst,
    input wire [15:0]   V,        // Current membrane potential
    output reg [15:0]   I_NA    // Next membrane potential (feedback output)
    );
    // Internal constants
    reg [15:0] G_K, E_K;
    wire n;

    update_n n_next (.clk(clk), .reset(rst), V.(V), .dt(), .n(n));

    // Calculate next membrane potential using discretized equation
    always @(posedge clk or posedge rst) begin

        // Hodgkin-Huxley constants
        G_K <= 36.0;
        E_K <= -54.4;

        if (rst) begin
            I_K <= 0;  // Initial membrane potential
        end else begin
            I_K <= G_K * n * (V - E_NA);
        end
    end
endmodule
