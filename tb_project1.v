module tb_project1;
    // 16-bit PPA Signals
    reg [15:0] ppa_A, ppa_B;
    reg ppa_Cin;
    wire [15:0] ppa_S;
    wire ppa_Cout;

    // 32-bit CLA Signals
    reg [31:0] cla_A, cla_B;
    reg cla_Cin;
    wire [31:0] cla_S;
    wire cla_Cout;

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
        // Dump waveform for EPWave simulation
        $dumpfile("dump.vcd");
      $dumpvars(0, tb_project1);

        $display("=== STARTING PPA & CLA SIMULATION TESTBENCH ===");
        
        // --- Test Cases for 16-bit PPA (Problem 3) ---
        ppa_A = 16'd100; ppa_B = 16'd200; ppa_Cin = 1'b0; #10;
        ppa_A = 16'hFFFF; ppa_B = 16'h0001; ppa_Cin = 1'b0; #10;
        ppa_A = 16'h1234; ppa_B = 16'h000F; ppa_Cin = 1'b1; #10;

        // --- Test Cases for 32-bit CLA (Problem 2) ---
        cla_A = 32'd150; cla_B = 32'd850; cla_Cin = 1'b0; #10;
        cla_A = 32'h0FFFFFFF; cla_B = 32'h00000001; cla_Cin = 1'b0; #10; // Multi-block carry propagation
        cla_A = 32'hFFFFFFFF; cla_B = 32'h00000001; cla_Cin = 1'b0; #10; // Carry-out generation / overflow
        cla_A = 32'hAAAAAAAA; cla_B = 32'h55555555; cla_Cin = 1'b1; #10; // Alternating bits stress test

        $finish;
    end

    initial begin
        $monitor("Time=%0t ns | PPA [A=%h, B=%h, Cin=%b] -> S=%h, Cout=%b | CLA [A=%h, B=%h, Cin=%b] -> S=%h, Cout=%b",
                 $time, ppa_A, ppa_B, ppa_Cin, ppa_S, ppa_Cout, cla_A, cla_B, cla_Cin, cla_S, cla_Cout);
    end
endmodule
