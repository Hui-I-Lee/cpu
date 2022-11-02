//Subject:     CO project  - Forwarding
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------

module Forwarding_unit(
	Rs_i,
	Rt_i,
	EM_Rd_i,
	MW_Rd_i,
	EM_RegWrite_i,
	MW_RegWrite_i,
	ForwardA_o,
	ForwardB_o
	);

// I/O ports
input 	[5-1:0] Rs_i;
input 	[5-1:0] Rt_i;
input 	[5-1:0] EM_Rd_i;
input 	[5-1:0] MW_Rd_i;
input   	EM_RegWrite_i;
input		MW_RegWrite_i;

output	[2-1:0]	ForwardA_o;
output	[2-1:0]	ForwardB_o;

//Internal Signals
reg		[2-1:0]	ForwardA_o;
reg		[2-1:0]	ForwardB_o;
reg 			if_ex_hazardA;
reg 			if_ex_hazardB;

//Parameter
//Main function
always @(*) begin
	if_ex_hazardA = 1'd0;
	if_ex_hazardB = 1'd0;
	ForwardA_o = 1'd0;
	ForwardB_o = 1'd0;
	if(EM_RegWrite_i & (EM_Rd_i != 5'd0) & (EM_Rd_i == Rs_i)) begin
		ForwardA_o <= 2'd2;
		if_ex_hazardA = 1'd1;
	end
	if(EM_RegWrite_i & (EM_Rd_i != 5'd0) & (EM_Rd_i == Rt_i)) begin
		ForwardB_o <= 2'd2;
		if_ex_hazardB = 1'd1;
	end
	if(MW_RegWrite_i & (MW_Rd_i != 5'd0) & (MW_Rd_i == Rs_i) & (!if_ex_hazardA)) begin
		ForwardA_o <= 2'd1;
	end
	if(MW_RegWrite_i & (MW_Rd_i != 5'd0) & (MW_Rd_i == Rt_i) & (!if_ex_hazardB)) begin
		ForwardB_o <= 2'd1;
	end
end
endmodule