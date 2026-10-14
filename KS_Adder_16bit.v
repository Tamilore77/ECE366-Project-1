// ====================================================
// Problem 1(a): 1-bit Full Adder (Behavioral Modeling)
// ====================================================
module one_bit_full_adder_beh (A, B, Cin, S, Cout);
    input A, B, Cin;
    output reg S, Cout;
    
    always @(*) begin
        {Cout, S} = A + B + Cin;
    end
endmodule


// ====================================================
// Problem 1(b): 1-bit Full Adder (Structural Modeling)
// ====================================================
module one_bit_full_adder (A, B, Cin, S, Cout);
    input A, B, Cin;
    output S, Cout;
    
    wire w1, w2, w3;
    
    // Sum = A ^ B ^ Cin
    xor (w1, A, B);
    xor (S, w1, Cin);
    
    // Cout = (A & B) | (Cin & (A ^ B))
    and (w2, A, B);
    and (w3, w1, Cin);
    or  (Cout, w2, w3);
endmodule


// ====================================================
// Problem 1(c) & (d): 4-bit Ripple-Carry Adder/Subtractor
// ====================================================
module four_bit_RCA_RCS (A, B, Cin, S, Cout);
    input [3:0] A, B;
    input Cin; // Subtraction control signal
    output [3:0] S;
    output Cout;
    
    wire [3:0] B_mux;
    wire c1, c2, c3;
    
    assign B_mux[0] = Cin ? ~B[0] : B[0];
    assign B_mux[1] = Cin ? ~B[1] : B[1];
    assign B_mux[2] = Cin ? ~B[2] : B[2];
    assign B_mux[3] = Cin ? ~B[3] : B[3];
    
    one_bit_full_adder fa0 (.A(A[0]), .B(B_mux[0]), .Cin(Cin), .S(S[0]), .Cout(c1));
    one_bit_full_adder fa1 (.A(A[1]), .B(B_mux[1]), .Cin(c1),  .S(S[1]), .Cout(c2));
    one_bit_full_adder fa2 (.A(A[2]), .B(B_mux[2]), .Cin(c2),  .S(S[2]), .Cout(c3));
    one_bit_full_adder fa3 (.A(A[3]), .B(B_mux[3]), .Cin(c3),  .S(S[3]), .Cout(Cout));
endmodule


// ====================================================
// Problem 2(a): 32-bit Carry Lookahead Adder (CLA)
// ====================================================
module cla_4bit (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Gout,
    output Pout,
    output Cout
);
    wire [3:0] G, P;
    wire [4:1] C;

    assign G = A & B;
    assign P = A ^ B;

    assign C[1] = G[0] | (P[0] & Cin);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & Cin);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & Cin);
    assign C[4] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & Cin);

    assign S[0] = P[0] ^ Cin;
    assign S[1] = P[1] ^ C[1];
    assign S[2] = P[2] ^ C[2];
    assign S[3] = P[3] ^ C[3];

    assign Gout = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
    assign Pout = P[3] & P[2] & P[1] & P[0];
    assign Cout = C[4];
endmodule

module CLA (A, B, Cin, S, Cout);
    input [31:0] A, B;
    input Cin;
    output [31:0] S;
    output Cout;
    
    wire [7:0] G, P;
    wire [8:0] C;
    
    assign C[0] = Cin;

    genvar idx;
    generate
        for (idx = 0; idx < 8; idx = idx + 1) begin : cla_blocks
            cla_4bit cla_inst (
                .A(A[(idx*4)+3 : idx*4]),
                .B(B[(idx*4)+3 : idx*4]),
                .Cin(C[idx]),
                .S(S[(idx*4)+3 : idx*4]),
                .Gout(G[idx]),
                .Pout(P[idx]),
                .Cout()
            );
            assign C[idx+1] = G[idx] | (P[idx] & C[idx]);
        end
    endgenerate

    assign Cout = C[8];
endmodule


// ====================================================
// Problem 3(a): 16-bit Parallel Prefix Adder (PPA)
// ====================================================
module PPA (A, B, Cin, S, Cout);
    input [15:0] A, B;
    input Cin;
    output [15:0] S;
    output Cout;

    wire [15:0] p_gen, g_gen;
    
    genvar p_idx;
    generate
        for (p_idx = 0; p_idx < 16; p_idx = p_idx + 1) begin : b_gen
            assign p_gen[p_idx] = A[p_idx] | B[p_idx];
            assign g_gen[p_idx] = A[p_idx] & B[p_idx];
        end
    endgenerate

    wire [16:0] c;
    assign c[0] = Cin;

    assign c[1]  = g_gen[0]  | (p_gen[0]  & Cin);
    assign c[2]  = g_gen[1]  | (p_gen[1]  & g_gen[0])  | (p_gen[1]  & p_gen[0]  & Cin);
    assign c[3]  = g_gen[2]  | (p_gen[2]  & g_gen[1])  | (p_gen[2]  & p_gen[1]  & g_gen[0])  | (p_gen[2]  & p_gen[1]  & p_gen[0]  & Cin);
    assign c[4]  = g_gen[3]  | (p_gen[3]  & g_gen[2])  | (p_gen[3]  & p_gen[2]  & g_gen[1])  | (p_gen[3]  & p_gen[2]  & p_gen[1]  & g_gen[0])  | (p_gen[3]  & p_gen[2]  & p_gen[1]  & p_gen[0]  & Cin);
    
    assign c[5]  = g_gen[4]  | (p_gen[4]  & c[4]);
    assign c[6]  = g_gen[5]  | (p_gen[5]  & c[5]);
    assign c[7]  = g_gen[6]  | (p_gen[6]  & c[6]);
    assign c[8]  = g_gen[7]  | (p_gen[7]  & c[7]);
    assign c[9]  = g_gen[8]  | (p_gen[8]  & c[8]);
    assign c[10] = g_gen[9]  | (p_gen[9]  & c[9]);
    assign c[11] = g_gen[10] | (p_gen[10] & c[10]);
    assign c[12] = g_gen[11] | (p_gen[11] & c[11]);
    assign c[13] = g_gen[12] | (p_gen[12] & c[12]);
    assign c[14] = g_gen[13] | (p_gen[13] & c[13]);
    assign c[15] = g_gen[14] | (p_gen[14] & c[14]);
    assign Cout  = g_gen[15] | (p_gen[15] & c[15]);

    wire g_0_neg1;
    assign g_0_neg1 = g_gen[0] | (p_gen[0] & Cin);

    assign S[0] = Cin ^ (A[0] ^ B[0]);
    assign S[1] = g_0_neg1 ^ (A[1] ^ B[1]);
    assign S[2]  = c[2]  ^ (A[2]  ^ B[2]);
    assign S[3]  = c[3]  ^ (A[3]  ^ B[3]);
    assign S[4]  = c[4]  ^ (A[4]  ^ B[4]);
    assign S[5]  = c[5]  ^ (A[5]  ^ B[5]);
    assign S[6]  = c[6]  ^ (A[6]  ^ B[6]);
    assign S[7]  = c[7]  ^ (A[7]  ^ B[7]);
    assign S[8]  = c[8]  ^ (A[8]  ^ B[8]);
    assign S[9]  = c[9]  ^ (A[9]  ^ B[9]);
    assign S[10] = c[10] ^ (A[10] ^ B[10]);
    assign S[11] = c[11] ^ (A[11] ^ B[11]);
    assign S[12] = c[12] ^ (A[12] ^ B[12]);
    assign S[13] = c[13] ^ (A[13] ^ B[13]);
    assign S[14] = c[14] ^ (A[14] ^ B[14]);
    assign S[15] = c[15] ^ (A[15] ^ B[15]);
endmodule


// ====================================================
// Problem 4(a): 16-bit Kogge-Stone (KS) Adder (Bonus)
// ====================================================
module KS_Adder_16bit (
    input [15:0] A,
    input [15:0] B,
    input Cin,
    output [15:0] S,
    output Cout
);
    wire [15:0] P0, G0;

    // Level 0: Pre-computation block
    genvar gi;
    generate
        for (gi = 0; gi < 16; gi = gi + 1) begin : l0_gen
            assign P0[gi] = A[gi] ^ B[gi];
            assign G0[gi] = A[gi] & B[gi];
        end
    endgenerate

    wire [16:0] G_net [4:0];
    wire [16:0] P_net [4:0];

    assign G_net[0][0] = Cin;
    assign P_net[0][0] = 1'b0;

    genvar gj;
    generate
        for (gj = 0; gj < 16; gj = gj + 1) begin : init_l0_gen
            assign G_net[0][gj+1] = G0[gj];
            assign P_net[0][gj+1] = P0[gj];
        end
    endgenerate

    // Level 1 (Distance 1)
    genvar g1;
    generate
        for (g1 = 0; g1 < 17; g1 = g1 + 1) begin : l1_gen
            if (g1 < 1) begin
                assign G_net[1][g1] = G_net[0][g1];
                assign P_net[1][g1] = P_net[0][g1];
            end else begin
                wire and_g1, and_p1, or_g1;
                and (and_g1, P_net[0][g1], G_net[0][g1-1]);
                or  (or_g1,  G_net[0][g1], and_g1);
                and (and_p1, P_net[0][g1], P_net[0][g1-1]);
                
                assign G_net[1][g1] = or_g1;
                assign P_net[1][g1] = and_p1;
            end
        end
    endgenerate

    // Level 2 (Distance 2)
    genvar g2;
    generate
        for (g2 = 0; g2 < 17; g2 = g2 + 1) begin : l2_gen
            if (g2 < 2) begin
                assign G_net[2][g2] = G_net[1][g2];
                assign P_net[2][g2] = P_net[1][g2];
            end else begin
                wire and_g2, and_p2, or_g2;
                and (and_g2, P_net[1][g2], G_net[1][g2-2]);
                or  (or_g2,  G_net[1][g2], and_g2);
                and (and_p2, P_net[1][g2], P_net[1][g2-2]);
                
                assign G_net[2][g2] = or_g2;
                assign P_net[2][g2] = and_p2;
            end
        end
    endgenerate

    // Level 3 (Distance 4)
    genvar g3;
    generate
        for (g3 = 0; g3 < 17; g3 = g3 + 1) begin : l3_gen
            if (g3 < 4) begin
                assign G_net[3][g3] = G_net[2][g3];
                assign P_net[3][g3] = P_net[2][g3];
            end else begin
                wire and_g3, and_p3, or_g3;
                and (and_g3, P_net[2][g3], G_net[2][g3-4]);
                or  (or_g3,  G_net[2][g3], and_g3);
                and (and_p3, P_net[2][g3], P_net[2][g3-4]);
                
                assign G_net[3][g3] = or_g3;
                assign P_net[3][g3] = and_p3;
            end
        end
    endgenerate

    // Level 4 (Distance 8)
    genvar g4;
    generate
        for (g4 = 0; g4 < 17; g4 = g4 + 1) begin : l4_gen
            if (g4 < 8) begin
                assign G_net[4][g4] = G_net[3][g4];
                assign P_net[4][g4] = P_net[3][g4];
            end else begin
                wire and_g4, and_p4, or_g4;
                and (and_g4, P_net[3][g4], G_net[3][g4-8]);
                or  (or_g4,  G_net[3][g4], and_g4);
                and (and_p4, P_net[3][g4], P_net[3][g4-8]);
                
                assign G_net[4][g4] = or_g4;
                assign P_net[4][g4] = and_p4;
            end
        end
    endgenerate

    assign Cout = G_net[4][16];

    genvar gk;
    generate
        for (gk = 0; gk < 16; gk = gk + 1) begin : post_comp
            xor (S[gk], G_net[4][gk], P0[gk]);
        end
    endgenerate

endmodule
