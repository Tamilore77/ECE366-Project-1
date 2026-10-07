// Part (a): 1-bit full-adder using behavioral modeling
module one_bit_full_adder_beh (A, B, Cin, S, Cout);
    input A, B, Cin;
    output reg S, Cout;
    
    always @(*) begin
        {Cout, S} = A + B + Cin;
    end
endmodule

// Part (b): 1-bit full-adder using structural modeling
// This implementation matches the gate-level schematic from Lecture Slide 2, Slide 12.
module one_bit_full_adder (A, B, Cin, S, Cout);
    input A, B, Cin;
    output S, Cout;
    
    wire w1, w2, w3;
    
    // Sum logic: S = A ^ B ^ Cin
    xor (w1, A, B);
    xor (S, w1, Cin);
    
    // Carry-out logic: Cout = (A & B) | (Cin & (A ^ B))
    and (w2, A, B);
    and (w3, w1, Cin);
    or  (Cout, w2, w3);
endmodule

// Part (c) & (d): 4-bit Ripple-Carry Adder/Subtractor (RCA/RCS)
// This implementation utilizes the programmable adder/subtractor logic from Lecture Slide 2, Slide 18.
module four_bit_RCA_RCS (A, B, Cin, S, Cout);
    input [3:0] A, B;
    input Cin;        // Acts as the 'sub' control signal
    output [3:0] S;
    output Cout;
    
    wire [3:0] B_mux; // Output of the 2-to-1 MUX
    wire c1, c2, c3;  // Internal carry wires
    
    // Programmable MUX: Selects B if Cin (sub) = 0, or negated B (~B) if Cin (sub) = 1
    assign B_mux[0] = Cin ? ~B[0] : B[0];
    assign B_mux[1] = Cin ? ~B[1] : B[1];
    assign B_mux[2] = Cin ? ~B[2] : B[2];
    assign B_mux[3] = Cin ? ~B[3] : B[3];
    
    // Instantiate 1-bit full adders using structural modeling
    // The initial carry-in is tied to 'Cin' to add the required +1 for 2's complement subtraction
    one_bit_full_adder fa0 (.A(A[0]), .B(B_mux[0]), .Cin(Cin), .S(S[0]), .Cout(c1));
    one_bit_full_adder fa1 (.A(A[1]), .B(B_mux[1]), .Cin(c1),  .S(S[1]), .Cout(c2));
    one_bit_full_adder fa2 (.A(A[2]), .B(B_mux[2]), .Cin(c2),  .S(S[2]), .Cout(c3));
    one_bit_full_adder fa3 (.A(A[3]), .B(B_mux[3]), .Cin(c3),  .S(S[3]), .Cout(Cout));
    
endmodule
