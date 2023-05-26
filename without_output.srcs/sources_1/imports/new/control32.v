`timescale 1ns / 1ps


/**
 * Base on the MINISYS ISA which has differences in the instruction encoding to MIPS32
 * extended several instructions that the compiler supports
 */
module control32(Opcode,
                 Function_opcode,
                 Alu_resultHigh,
                 Branch,
                 nBranch,
                 Jr,
                 Jmp,
                 Jal,
                 ALUSrc,
                 ALUOp,
                 MemWrite,
                 MemRead,
                 IORead,
                 IOWrite,
                 RegWrite,
                 RegDST,
                 MemorIOtoReg,
                 I_format,
                 Sftmd);
    
    input[5:0]   Opcode;            // ????IFetch????????6bit, instruction[31..26]
    input[5:0]   Function_opcode;  	// ????IFetch????????6bit, ????????r-?????��????, instructions[5..0]
    input[21:0]  Alu_resultHigh;     // ????ALU????????��, instruction[25..0]
    
    output       Branch;            // ?1??????beq???, ?0????????beq???
    output       nBranch;           // ?1??????bne???, ?0????????bne???
    
    output       Jr;         	    // ?1????????????jr, ?0???????????jr
    output       Jmp;               // ?1??????J???, ?0????????J???
    output       Jal;               // ?1??????Jal???, ?0????????Jal???
    
    output       ALUSrc;            // ?1?????????????????ALU?��?Binput????????????beq, bne????, ?0???????????????????????
    
    output[1:0]  ALUOp;             // ??R-?????I_format = 1?��1????bit��???1,  beq??bne?????��0????bit��???1
    
    output       MemWrite;          // ?1????????????��?��??
    output       MemRead;           // ?1???????????????��??

    output       IORead;            // ?1??????????????IO
    output       IOWrite;           // ?1????????????��IO
    
    output       RegWrite;    	    // ?1????????????��?????
    output       RegDST;            // ?1?????????????rd, ?????????????rt
    output       MemorIOtoReg;          // ?1?????????��????I/O????????????
    
    output       I_format;          // ?1????????????beq, bne, LW, SW????????I-???????
    output       Sftmd;             // ?1????????��???, ?0??????????��???
    
    
    wire R_format, sw, lw;
    
    ///////////////////////////////////////////////////////////////////////////////
    
    assign R_format = Opcode == 'b000_000;
    assign I_format = Opcode[5:3] == 'b001;  // ignore all branch / load / store

    assign sw = Opcode == 'b101_011;
    assign lw = Opcode == 'b100_011;
    
    assign Jmp = Opcode == 'b000_010;  // J-format
    assign Jal = Opcode == 'b000_011;  // J-format
    assign Jr  = R_format && (Function_opcode == 'b001_000);
    
    assign Branch  = Opcode == 'b000_100;
    assign nBranch = Opcode == 'b000_101;
    
    assign ALUOp = {R_format || I_format, Branch || nBranch};
    
    // only 'sw' for MINISYS
    assign MemWrite =(sw && (Alu_resultHigh[21:0] != 22'h3FFFFF));
    assign MemRead = (lw && (Alu_resultHigh[21:0] != 22'h3FFFFF));

    assign IOWrite = (sw && (Alu_resultHigh[21:0] == 22'h3FFFFF));
    assign IORead = (lw && (Alu_resultHigh[21:0] == 22'h3FFFFF));
    
    assign ALUSrc = I_format || Opcode[5] == 'b1;  // + load / store
    
    // sll, srl, sra, sllv, srlv, srav
    assign Sftmd = R_format && (Function_opcode[5:3] == 'b000);
    
    // R-formats -> rd, // but jr/div/divu/mult/multu don't
    assign RegDST = R_format;
    
    assign RegWrite = R_format && !Jr || I_format || Jal || Opcode == 'b100_011   // lw
            || (Opcode == 0 && Function_opcode[5:4] == 'b01 && Function_opcode[2] == 'b0);  // ext calc

    
    // lwc1, ldc1 -> Opcode = 0x31 / 0x35
    // lbu, lhu, ll, lw -> 0x23, 0x24, 0x25, 0x30
    assign MemorIOtoReg = IORead || MemRead;
endmodule