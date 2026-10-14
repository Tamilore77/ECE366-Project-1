module tb_project1_bonus;
    // 16-bit Kogge-Stone Adder Signals (Problem 4)
    reg [15:0] ks_A, ks_B;
    reg ks_Cin;
    wire [15:0] ks_S;
    wire ks_Cout;

    // 16-bit PPA Signals (Problem 3)
    reg [15:0] ppa_A, ppa_B;
    reg ppa_Cin;
    wire [15:0] ppa_S;
    wire ppa_Cout;

    // 32-bit CLA Signals (Problem 2)
    reg [31:0] cla_A, cla_B;
    reg cla_Cin;
    wire [31:0] cla_S;
    wire cla_Cout;

    // Instantiate Kogge-Stone Adder (Problem 4)[cite: 6]
    KS_Adder_16bit u_ks (
        .A(ks_A),
        .B(ks_B),
        .Cin(ks_Cin),
        .S(ks_S),
        .Cout(ks_Cout)
    );

    // Instantiate PPA Module (Problem 3)
    PPA u_ppa (
        .A(ppa_A),
        .B(ppa_B),
        .Cin(ppa_Cin),
        .S(ppa_S),
        .Cout(ppa_Cout)
    );

    // Instantiate CLA Module (Problem 2)
    CLA u_cla (
        .A(cla_A),
        .B(cla_B),
        .Cin(cla_Cin),
        .S(cla_S),
        .Cout(cla_Cout)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0);

        $display("=== STARTING BONUS KOGGE-STONE & COMPREHENSIVE TESTBENCH ===");
        
        // --- Test Cases for 16-bit Kogge-Stone Adder (Problem 4)[cite: 6] ---
        ks_A = 16'd500;  ks_B = 16'd300;  ks_Cin = 1'b0; #10;
        ks_A = 16'hFFFF; ks_B = 16'h0001; ks_Cin = 1'b0; #10; // Carry out overflow test
        ks_A = 16'hABCD; ks_B = 16'h1234; ks_Cin = 1'b1; #10; // Addition with carry-in

        // --- Test Cases for 16-bit PPA (Problem 3) ---
        ppa_A = 16'd100; ppa_B = 16'd200; ppa_Cin = 1'b0; #10;
        ppa_A = 16'hFFFF; ppa_B = 16'h0001; ppa_Cin = 1'b0; #10;

        // --- Test Cases for 32-bit CLA (Problem 2) ---
        cla_A = 32'd150; cla_B = 32'hFFFFFFFF; cla_Cin = 1'b0; #10;

        $finish;
    end

    initial begin
        $monitor("Time=%0t ns | KS Adder [A=%h, B=%h, Cin=%b] -> S=%h, Cout=%b",
                 $time, ks_A, ks_B, ks_Cin, ks_S, ks_Cout);
    end
endmodule
