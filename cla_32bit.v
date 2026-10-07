// 4-bit Carry Lookahead Adder Block
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

    // Sum calculation
    assign S[0] = P[0] ^ Cin;
    assign S[1] = P[1] ^ C[1];
    assign S[2] = P[2] ^ C[2];
    assign S[3] = P[3] ^ C[3];

    // Block Generate and Propagate
    assign Gout = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
    assign Pout = P[3] & P[2] & P[1] & P[0];
    assign Cout = C[4];
endmodule

// 32-bit Carry Lookahead Adder 
module cla_32bit (
    input [31:0] A,
    input [31:0] B,
    input Cin,
    output [31:0] S,
    output Cout
);
    wire [7:0] G, P;
    wire [8:0] C;
    
    assign C[0] = Cin;

    
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : cla_blocks
            cla_4bit cla_inst (
                .A(A[(i*4)+3 : i*4]),
                .B(B[(i*4)+3 : i*4]),
                .Cin(C[i]),
                .S(S[(i*4)+3 : i*4]),
                .Gout(G[i]),
                .Pout(P[i]),
                .Cout() 
            );
            
            
            assign C[i+1] = G[i] | (P[i] & C[i]);
        end
    endgenerate

    assign Cout = C[8];
endmodule
