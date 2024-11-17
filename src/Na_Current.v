module sodiumCurrent (
    input wire          clk,
    input wire          rst,
    wire signed [15:0]  dt,
    input wire signed [15:0] V,  // Current membrane potential
    output reg signed [15:0] I_NA // Sodium current
);

    wire signed [15:0] m, h;

    // Instantiate the update_m and update_h modules
    update_m m_next (
        .clk(clk),
        .reset(rst),
        .V(V),
        .dt(dt),
        .m_next(m)
    );

    update_h h_next (
        .clk(clk),
        .reset(rst),
        .V(V),
        .dt(dt),
        .h_next(h)
    );

    // Initialize I_NA
    initial begin
        I_NA = 16'd0; // Initial value for I_NA
    end

    // Calculate sodium current using discretized equation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            I_NA <= 16'd0;  // Reset sodium current
        end else begin
            I_NA <= (16'd1200 * (m * 16'd10) * (m * 16'd10) * (m * 16'd10) * (h * 16'd10) * ((V * 16'd10) - 16'd500)) / 16'd10; // Directly use constants and scale result by 10
        end
    end
endmodule
