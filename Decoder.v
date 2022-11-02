//Subject:     CO project 4 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Luke
//----------------------------------------------
//Date:        2010/8/16
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Decoder(
    instr_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o,
        MemRead_o,
	MemWrite_o,
	MemtoReg_o,
	BranchType_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
//outpu	       Jump_o;
output	       MemRead_o;
output         MemWrite_o;
output         MemtoReg_o;
output [2-1:0] BranchType_o;
 
//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o;
reg            Branch_o;
//reg	       Jump_o;
reg	       MemRead_o;
reg            MemWrite_o;
reg            MemtoReg_o;
reg    [2-1:0] BranchType_o;

//Parameter
reg [11-1:0] result;

//Main function
always @(instr_op_i)
begin
	case(instr_op_i)
	6'b000000: begin //R 
		ALU_op_o <= 3'b000;
		ALUSrc_o <= 0;
      		Branch_o <= 0;
      		RegWrite_o <= 1;
		RegDst_o <= 1;
      		MemtoReg_o <= 1;
      		MemRead_o <= 0;
      		MemWrite_o <= 0;
		BranchType_o <= 00;
		//Jump_o <= 1;
		end
	/*6'b000010: begin //jump
		ALU_op_o <= 3'b110;
		ALUSrc_o <= 0;
      		Branch_o <= 0;
      		RegWrite_o <= 0;
		RegDst_o <= 0;
      		MemtoReg_o <= 0;
      		MemRead_o <= 0;
      		MemWrite_o <= 0;
		Jump_o <= 0;
		end
	6'b000011: begin //jal
		ALU_op_o <= 3'b111;
		ALUSrc_o <= 0;
      		Branch_o <= 0;
      		RegWrite_o <= 1;
		RegDst_o <= 0;
      		MemtoReg_o <= 0;
      		MemRead_o <= 0;
      		MemWrite_o <= 0;
		Jump_o <= 0;
		end*/
	6'b000100: begin //beq
		ALU_op_o <= 3'b011;
		ALUSrc_o <= 0;
      		Branch_o <= 1;
      		RegWrite_o <= 0;
		RegDst_o <= 0;
      		MemtoReg_o <= 0;
      		MemRead_o <= 0;
      		MemWrite_o <= 0;
		BranchType_o <= 00;
		//Jump_o <= 1;
		end
	6'b001000: begin //addi
		ALU_op_o <= 3'b001;
		ALUSrc_o <= 1;
      		Branch_o <= 0;
      		RegWrite_o <= 1;
		RegDst_o <= 0;
      		MemtoReg_o <= 1;
      		MemRead_o <= 0;
      		MemWrite_o <= 0;
		BranchType_o <= 00;
		//Jump_o <= 1;
		end
	6'b001010: begin //slti
		ALU_op_o <= 3'b010;
		ALUSrc_o <= 1;
      		Branch_o <= 0;
      		RegWrite_o <= 0;
		RegDst_o <= 0;
      		MemtoReg_o <= 0;
      		MemRead_o <= 0;
      		MemWrite_o <= 0;
		BranchType_o <= 00;
		//Jump_o <= 1;
		end
	6'b100011: begin //lw
		ALU_op_o <= 3'b100;
		ALUSrc_o <= 1;
      		Branch_o <= 0;
      		RegWrite_o <= 1;
		RegDst_o <= 0;
      		MemtoReg_o <= 0; //l
      		MemRead_o <= 1;
      		MemWrite_o <= 0;
		BranchType_o <= 00;
		//Jump_o <= 1;
		end
	6'b101011: begin //sw
		ALU_op_o <= 3'b101;
		ALUSrc_o <= 1;
      		Branch_o <= 0;
      		RegWrite_o <= 0;
		RegDst_o <= 0;
      		MemtoReg_o<= 0;
      		MemRead_o <= 0;
      		MemWrite_o <= 1; //store
		BranchType_o <= 00;
		//Jump_o <= 1;
		end
	6'b000001: begin //bge 
		ALU_op_o <= 3'b011;
		ALUSrc_o <= 0;
      		Branch_o <= 1;
      		RegWrite_o <= 0;
		RegDst_o <= 0;
      		MemtoReg_o<= 1;
      		MemRead_o <= 0;
      		MemWrite_o <= 0; 
		BranchType_o <= 10;
		end
	6'b000101: begin //BNE 
		ALU_op_o <= 3'b011;
		ALUSrc_o <= 0;
      		Branch_o <= 1;
      		RegWrite_o <= 0;
		RegDst_o <= 0;
      		MemtoReg_o<= 1;
      		MemRead_o <= 0;
      		MemWrite_o <= 0; 
		BranchType_o <= 11;
		end
	6'b000111: begin //BGT 
		ALU_op_o <= 3'b011;
		ALUSrc_o <= 0;
      		Branch_o <= 1;
      		RegWrite_o <= 0;
		RegDst_o <= 0;
      		MemtoReg_o<= 1;
      		MemRead_o <= 0;
      		MemWrite_o <= 0; 
		BranchType_o <= 01;
		end
	endcase
end
endmodule





                    
                    