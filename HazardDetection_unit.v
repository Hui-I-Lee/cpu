//Subject:     CO project  - HazardDetection
//--------------------------------------------------------------------------------
//Version:     
//--------------------------------------------------------------------------------

module HazardDetection_unit(
	branch,
	DE_MemRead_i,
	DE_Rt_i,
	FD_Rs_i,
	FD_Rt_i,
	PCWrite_o,
	FDWrite_o,
	IF_ID_Flush_o,
	ID_EX_Flush_o,
	EX_MEM_Flush_o
	);

// I/O ports
input  			branch;
input 			DE_MemRead_i;
input	[5-1:0] DE_Rt_i;
input	[5-1:0] FD_Rs_i;
input	[5-1:0] FD_Rt_i;

output 			PCWrite_o;
output 			FDWrite_o; 
output 			IF_ID_Flush_o;
output 			ID_EX_Flush_o;
output 			EX_MEM_Flush_o;

//Internal Signals
reg	 			PCWrite_o;
reg 			FDWrite_o; 
reg 			IF_ID_Flush_o;
reg 			ID_EX_Flush_o;
reg 			EX_MEM_Flush_o;

//Parameter

//Main function
always @(*) begin
	// Branch
	if(branch)begin
		PCWrite_o <= 1'd1;
		FDWrite_o <= 1'd0;
		IF_ID_Flush_o <= 1'd1;
		ID_EX_Flush_o <= 1'd1;
		EX_MEM_Flush_o <= 1'd1;
	end

	// Load hazard
	else if(DE_MemRead_i & ((DE_Rt_i == FD_Rs_i) | (DE_Rt_i == FD_Rt_i))) begin
		PCWrite_o <= 1'd0;
		FDWrite_o <= 1'd0;
		IF_ID_Flush_o <= 1'd0;
		ID_EX_Flush_o <= 1'd1;
		EX_MEM_Flush_o <= 1'd0;
	end

	//no hazard
	else begin
		PCWrite_o <= 1'd1;
		FDWrite_o <= 1'd1;
		IF_ID_Flush_o <= 1'd0;
		ID_EX_Flush_o <= 1'd0;
		EX_MEM_Flush_o <= 1'd0;
	end
end
endmodule