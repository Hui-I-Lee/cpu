`timescale 1ns / 1ps
//Subject:     CO project 4 - Pipe CPU 1
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Pipe_CPU_1(
    clk_i,
    rst_i
    );
    
/****************************************
I/O ports
****************************************/
input clk_i;
input rst_i;

/****************************************
Internal signal
****************************************/
/**** IF stage ****/
wire [32-1:0] pc_4;
wire [32-1:0] pc_i;
wire [32-1:0] pc_o;
wire [32-1:0] IF_instr;

/**** ID stage ****/
wire [32-1:0] ID_addr;
wire [32-1:0] ID_instr;
wire [32-1:0] ID_RD_1;
wire [32-1:0] ID_RD_2;
wire [32-1:0] ID_se_o;

// Hazard
wire [5 -1:0] IF_ID_Rs;
wire [5 -1:0] IF_ID_Rt;
wire [5 -1:0] IF_ID_Rd;

//control signal
//EX
wire [3 -1:0] ID_ALUop;
wire 	      ID_ALUsrc;
wire 	      ID_RegDst;
wire [5 -1:0] ID_ex;
// M
wire 	      ID_branch;
wire 	      ID_MemRead;
wire 	      ID_MemWrite;
wire [5 -1:0] ID_M;
wire [2 -1:0] ID_BranchType;
// WB
wire 	      ID_RegWrite;
wire 	      ID_MemtoReg;
wire [2 -1:0] ID_WB;

// Hazard
wire 		  IF_ID_Write;
wire   		  PC_Write;
wire 		  ID_EX_MemRead;

/**** EX stage ****/
wire [32-1:0] EX_b;
wire [32-1:0] EX_addr;
wire [5 -1:0] EX_RDaddr;
wire [32-1:0] EX_RD_1;
wire [32-1:0] EX_RD_2;
wire [32-1:0] EX_se_o;
wire [32-1:0] EX_ALU_result;
wire 	      EX_zero;

wire [32 -1:0] ALU_i0;
wire [32 -1:0] ALU_i1;
wire [32-1:0] ALU_addr_i1;
//wire [32-1:0] shift_32;
wire [4 -1:0] ALU_Ctrl;
wire [6 -1:0] funct;

// Hazard
wire [5 -1:0] Rs;
wire [5 -1:0] Rt;
wire [5 -1:0] Rd;
wire [32-1:0] F_i0;

//control signal
// EX
wire [5 -1:0] EX_EX;
wire [3 -1:0] ALU_op;
wire 	      ALUsrc;
wire 	      RegDst;

// M
wire [5 -1:0] EX_M;

// WB
wire [2 -1:0] EX_WB;

// Hazard
wire [2 -1:0] ForwardA;
wire [2 -1:0] ForwardB;

/**** MEM stage ****/
wire [32-1:0] MEM_b;
wire [5 -1:0] MEM_RDaddr;
wire [32-1:0] MEM_addr;
wire [32-1:0] MEM_Writedata;
wire [32-1:0] MEM_Read_data;
wire  	      MEM_zero;

// Branch
wire 		beq;
wire  		bgt;
wire   		bge;
wire   		bne;
wire 		brtype;
wire 		IF_ID_Flush;
wire 		ID_EX_Flush;
wire 		EX_MEM_Flush;

//control signal
wire 	     pc_src;
// M
wire [5 -1:0] MEM_M;
wire  	      MemWrite;
wire   	      MemRead;
wire          Branch;
wire [2 -1:0] BranchType;

// WB
wire [2 -1:0] MEM_wb;
/**** WB stage ****/
wire [5 -1:0] WB_RDaddr_o;
wire [32-1:0] WB_RD_data;
wire [32-1:0] WB1;
wire [32-1:0] WB2;

//control signal
// WB
wire [2 -1:0] WB_WB;
wire   	      RegWrite;
wire          MemtoReg;


/****************************************
Instantiate modules
****************************************/
//Instantiate the components in IF stage
MUX_2to1 #(.size(32)) Mux0(
        .data0_i(pc_4),
        .data1_i(MEM_b),
        .select_i(pc_src),
        .data_o(pc_i)
);

ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_in_i(pc_i) ,   
	    .pc_write_i(PC_Write),
	    .pc_out_o(pc_o)
);

Instruction_Memory IM(
        .addr_i(pc_o),  
	    .instr_o(IF_instr) 
);
			
Adder Add_pc(
        .src1_i(pc_o),     
	    .src2_i(32'd4),     
	    .sum_o(pc_4)   //IF_addr
);

		
/*Pipe_Reg #(.size(64)) IF_ID(       //N is the total length of input/output = 32+ 32= 64
	    .clk_i(clk_i),
	    .rst_i(rst_i),
	    .data_i({pc_4, IF_instr}), 
	    .data_o({ID_addr, ID_instr})
);*/

IF_Write_Pipe_Reg #(.size(64)) IF_ID(
	.clk_i(clk_i),
    	.rst_i(rst_i),
    	.select_write(IF_ID_Write),
    	.select_flush(IF_ID_Flush),
    	.data_i({pc_4, IF_instr}),
    	.data_o({ID_addr, ID_instr})
	);


//Instantiate the components in ID stage
Reg_File RF(
        .clk_i(clk_i),      
	    .rst_i(rst_i) ,     
        .RSaddr_i(ID_instr[25:21]) ,  
        .RTaddr_i(ID_instr[20:16]) ,  
        .RDaddr_i(WB_RDaddr_o) ,  
        .RDdata_i(WB_RD_data)  , 
        .RegWrite_i (RegWrite),
        .RSdata_o(ID_RD_1) ,  
        .RTdata_o(ID_RD_2) 
);

Decoder Control(
        .instr_op_i(ID_instr[31:26]), 
	    .RegWrite_o(ID_RegWrite), 
	    .ALU_op_o(ID_ALUop),   
	    .ALUSrc_o(ID_ALUsrc),   
	    .RegDst_o(ID_RegDst),   
	    .Branch_o(ID_branch),
    	    .MemRead_o(ID_MemRead),
	    .MemWrite_o(ID_MemWrite),
 	    .MemtoReg_o(ID_MemtoReg),
	    .BranchType_o(ID_BranchType) 
);

Sign_Extend Sign_Extend(
        .data_i(ID_instr[15:0]),
        .data_o(ID_se_o)
);	

// Hazard
HazardDetection_unit Hazard_detection(
		.branch(pc_src),
		.DE_MemRead_i(ID_EX_MemRead),
		.DE_Rt_i(Rt),
		.FD_Rs_i(IF_ID_Rs),
		.FD_Rt_i(IF_ID_Rt),
		.PCWrite_o(PC_Write),
		.FDWrite_o(IF_ID_Write),
		.IF_ID_Flush_o(IF_ID_Flush),
		.ID_EX_Flush_o(ID_EX_Flush),
		.EX_MEM_Flush_o(EX_MEM_Flush)		
);

/*Pipe_Reg #(.size(148)) ID_EX(
	    .clk_i(clk_i),
	    .rst_i(rst_i),
	    .data_i({ID_addr, ID_WB, ID_M, ID_ex,ID_RD_1, ID_RD_2, ID_se_o, ID_instr[15:11], ID_instr[20:16]}), 
	    .data_o({EX_addr, EX_WB, EX_M, EX_EX,EX_RD_1, EX_RD_2, EX_se_o, EX2,EX1})
);*/
Flush_Pipe_Reg #(.size(155)) ID_EX(
	    .clk_i(clk_i),
	    .rst_i(rst_i),
	    .select(ID_EX_Flush),
	    .data_i({ID_WB, ID_M, ID_ex, ID_addr, ID_RD_1, ID_RD_2, ID_se_o, IF_ID_Rs, IF_ID_Rt, IF_ID_Rd}), 
	    .data_o({EX_WB, EX_M, EX_EX, EX_addr, EX_RD_1, EX_RD_2, EX_se_o, Rs, Rt, Rd})
	);

//Instantiate the components in EX stage	   
Shift_Left_Two_32 Shifter(
	    .data_i(EX_se_o),
	    .data_o(ALU_addr_i1)
);

ALU ALU(
	    .src1_i(ALU_i0),
		.src2_i(ALU_i1),
		.ctrl_i(ALU_Ctrl),
		.result_o(EX_ALU_result),
		.zero_o(EX_zero)
);
		
ALU_Control ALU_Control(
	    .funct_i(funct),
	    .ALUOp_i(ALU_op),
	    .ALUCtrl_o(ALU_Ctrl)
);

// ALU input_0
MUX_3to1 #(.size(32)) ALU_Mux0(
        .data0_i(EX_RD_1),
        .data1_i(WB_RD_data),
        .data2_i(MEM_addr),
        .select_i(ForwardA),
        .data_o(ALU_i0)
);

// ForwardB
MUX_3to1 #(.size(32)) F_Mux(
        .data0_i(EX_RD_2),
        .data1_i(WB_RD_data),
        .data2_i(MEM_addr),
        .select_i(ForwardB),
        .data_o(F_i0)
);

// ALU input 1
MUX_2to1 #(.size(32)) ALU_Mux1(
        .data0_i(F_i0),
        .data1_i(EX_se_o),
        .select_i(ALUsrc),
        .data_o(ALU_i1)
);

// RD address	
MUX_2to1 #(.size(5)) Mux2(
        .data0_i(Rt),
        .data1_i(Rd),
        .select_i(RegDst),
        .data_o(EX_RDaddr)
);

Adder Add_pc_branch(
	    .src1_i(EX_addr),
		.src2_i(ALU_addr_i1),
		.sum_o(EX_b)    
);

// Forwarding unit
Forwarding_unit Forward(
	.Rs_i(Rs),
	.Rt_i(Rt),
	.EM_Rd_i(MEM_RDaddr),
	.MW_Rd_i(WB_RDaddr_o),
	.EM_RegWrite_i(MEM_wb[1]),	// MEM_Wb[1] = MEM.RegWrite
	.MW_RegWrite_i(RegWrite), 	// WB_RegWrite
	.ForwardA_o(ForwardA),
	.ForwardB_o(ForwardB)
	);

/*Pipe_Reg #(.size(107)) EX_MEM(
	    .clk_i(clk_i),
	    .rst_i(rst_i),
	    .data_i({EX_WB, EX_M, EX_b, EX_zero, EX_ALU_result, EX_RD_2, EX_RDaddr}), 
	    .data_o({MEM_wb, MEM_M, MEM_b, MEM_zero, MEM_addr, MEM_Writedata, MEM_RDaddr})
);*/
Flush_Pipe_Reg #(.size(109)) EX_MEM(
	    .clk_i(clk_i),
	    .rst_i(rst_i),
	    .select(EX_MEM_Flush),
	    .data_i({EX_WB, EX_M, EX_b, EX_zero, EX_ALU_result, F_i0, EX_RDaddr}), 
	    .data_o({MEM_wb, MEM_M, MEM_b, MEM_zero, MEM_addr, MEM_Writedata, MEM_RDaddr})
	);


//Instantiate the components in MEM stage
Data_Memory DM(
	    .clk_i(clk_i),
	    .addr_i(MEM_addr),
	    .data_i(MEM_Writedata),
	    .MemRead_i(MemRead),
	    .MemWrite_i(MemWrite),
	    .data_o(MEM_Read_data)
);

// BranchType
MUX_4to1 #(.size(1)) BrType(
	    .data0_i(beq),
        .data1_i(bgt),
        .data2_i(bge),
        .data3_i(bne),
        .select_i(BranchType),
        .data_o(brtype)
	);

Pipe_Reg #(.size(71)) MEM_WB(
	    .clk_i(clk_i),
	    .rst_i(rst_i),
	    .data_i({MEM_wb, MEM_Read_data, MEM_addr, MEM_RDaddr}), 
	    .data_o({WB_WB, WB1, WB2, WB_RDaddr_o})
);


//Instantiate the components in WB stage

MUX_2to1 #(.size(32)) Mux3(
        .data0_i(WB1),
        .data1_i(WB2),
        .select_i(MemtoReg),
        .data_o(WB_RD_data)
);

/****************************************
signal assignment
****************************************/
// ID 
assign ID_ex = {ID_RegDst, ID_ALUsrc, ID_ALUop};
assign ID_M  = {ID_BranchType, ID_branch, ID_MemRead, ID_MemWrite};
assign ID_WB = {ID_RegWrite, ID_MemtoReg};
assign IF_ID_Rs = ID_instr[25:21];
assign IF_ID_Rt = ID_instr[20:16];
assign IF_ID_Rd = ID_instr[15:11];

// EX 
assign ALU_op = EX_EX[2:0];
assign ALUsrc = EX_EX[3];
assign RegDst = EX_EX[4];
assign funct = EX_se_o[5:0];  
assign ID_EX_MemRead = EX_M[1];

// M 
assign BranchType = MEM_M[4:3];
assign Branch = MEM_M[2];
assign MemRead = MEM_M[1];
assign MemWrite = MEM_M[0];

assign beq = MEM_zero;
assign bgt = ~MEM_addr[31]; 		// MEM_addr[31] = signbit of ALU output
assign bge = MEM_zero | ~MEM_addr[31];
assign bne = ~MEM_zero;
assign pc_src = Branch & brtype;

// WB 
assign RegWrite = WB_WB[1];
assign MemtoReg = WB_WB[0];


endmodule

