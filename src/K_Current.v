module potassiumCurrent (
    input wire                  clk,
    input wire                  rst,
    input wire                  dt,
    input wire signed [15:0]    V,  // Current membrane potential
    output reg signed [15:0]    I_K // Potassium current
);
    // Internal wire for n
    wire signed [15:0] n;

    // Instantiate the update_n module
    update_n n_next (
        .clk(clk),
        .reset(rst),
        .V(V),
        .dt(dt),
        .n_next(n) // Drive the wire
    );

    // Combine registering `n` and calculating `I_K` in one block
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            I_K <= 16'd0;      // Reset potassium current
        end else begin
            // I_K = G_K * n^4 * (V - E_K)
            I_K <= (16'd360 * n * n * n * n * (V - -16'd544)) / 16'd10;
        end
    end
endmodule