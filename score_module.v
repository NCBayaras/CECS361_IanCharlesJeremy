module score_module (
    input wire clk,
    input wire reset,
    input wire one_point,
    input wire team, // Assuming this input selects between team 1 and team 2
    output wire [2:0] RGB1, // Assuming RGB is a 3-bit signal
    output wire [2:0] RGB2,
    output wire [6:0] p1, // Assuming a 7-bit score for team 1
    output wire [6:0] p2  // Assuming a 7-bit score for team 2
);

reg [6:0] p1 = 7'b0000000;
reg [6:0] p2 = 7'b0000000;
reg [1:0] overtime_count = 2'b00;
reg overtime_flag = 1'b0;

always @(posedge Time_to_Timing1) begin
    if (reset) begin
        p1 <= 7'b0000000;
        p2 <= 7'b0000000;
        overtime_flag <= 1'b0;
        overtime_count <= 2'b00;
    end

    if (one_point) begin
        if (team) begin
            p1 <= p1 + 1;
        end else begin
            p2 <= p2 + 1;
        end
    end
 if (p1 >= 7'b1101 || p2 >= 7'b1101) begin
        // Check for game win before overtime
        if (p1 >= 7'b1101) begin
            RGB1 = 3'b100;
            RGB2 = 3'b100;
            p1 <= 7'b0000;
        end
        if (p2 >= 7'b1101) begin
            RGB1 = 3'b001;
            RGB2 = 3'b001;
            p2 <= 7'b0000;
        end
        // Game win logic (e.g., Team 1 wins, Team 2 wins)
    end

endmodule