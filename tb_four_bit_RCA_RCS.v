module tb_four_bit_RCA_RCS;
    reg [3:0] A, B;
    reg Cin;
    wire [3:0] S;
    wire Cout;
    
    // Instantiate the Device Under Test (DUT)
    four_bit_RCA_RCS dut (
        .A(A), 
        .B(B), 
        .Cin(Cin), 
        .S(S), 
        .Cout(Cout)
    );
    
    initial begin
        // Setup waveform dumping for EDA Playground
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_four_bit_RCA_RCS);
        
        $display("Starting Testbench for 4-bit RCA/RCS...");
        $display("---------------------------------------------------------");
        
        // 1. Unsigned Addition (5 + 4 = 9)
        A = 4'd5; B = 4'd4; Cin = 1'b0; 
        #10;
        
        // 2. Unsigned Subtraction (9 - 4 = 5)
        A = 4'd9; B = 4'd4; Cin = 1'b1; 
        #10;
        
        // 3. Signed Addition involving a negative operand (-3 + 2 = -1)
        // Note: -3 in 4-bit 2's complement is 4'b1101
        A = 4'b1101; B = 4'b0010; Cin = 1'b0; 
        #10;
        
        // 4. Signed Subtraction involving a negative operand (2 - (-3) = 5)
        A = 4'b0010; B = 4'b1101; Cin = 1'b1; 
        #10;
        
        // 5. Case that produces a carry-out (10 + 7 = 17)
        // 10 is 4'b1010, 7 is 4'b0111. Sum should be 1 (4'b0001) with Cout = 1.
        A = 4'd10; B = 4'd7; Cin = 1'b0; 
        #10;
        
        $finish;
    end
    
    // Monitor and output results
    initial begin
        $monitor("Time = %0t | A = %b | B = %b | Cin (Sub) = %b | S = %b | Cout = %b", 
                 $time, A, B, Cin, S, Cout);
    end
endmodule
