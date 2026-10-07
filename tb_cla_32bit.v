module tb_cla_32bit;
    reg [31:0] A, B;
    reg Cin;
    wire [31:0] S;
    wire Cout;
    
  // (DUT) 
    cla_32bit dut (
        .A(A), 
        .B(B), 
        .Cin(Cin), 
        .S(S), 
        .Cout(Cout)
    );
    
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_cla_32bit);
        
        $display("Starting Testbench for 32-bit CLA...");
        $display("---------------------------------------------------------");
        
        // 1. Basic Unsigned Addition 
        A = 32'd150; B = 32'd850; Cin = 1'b0; 
        #10;
        
        // 2. Addition with Initial Carry
        A = 32'd150; B = 32'd850; Cin = 1'b1; 
        #10;
        
        // 3. Large Numbers 
        A = 32'h0FFFFFFF; B = 32'h00000001; Cin = 1'b0; 
        #10;
        
        // 4. Carry-out Generation 
        A = 32'hFFFFFFFF; B = 32'h00000001; Cin = 1'b0; 
        #10;
        
        // 5. Alternating Bits 
        A = 32'hAAAAAAAA; B = 32'h55555555; Cin = 1'b0; 
        #10;
        
        // 6. Alternating Bits with Carry 
        A = 32'hAAAAAAAA; B = 32'h55555555; Cin = 1'b1; 
        #10;
        
        $finish;
    end
    
    initial begin
        $monitor("Time = %0t | A = %h | B = %h | Cin = %b | S = %h | Cout = %b", 
                 $time, A, B, Cin, S, Cout);
    end
endmodule
