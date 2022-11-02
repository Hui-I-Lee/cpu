//Subject:     CO project 5 - Flush_Piple_Reg
//--------------------------------------------------------------------------------

module Flush_Pipe_Reg(
	clk_i,
        rst_i,
        select,
        data_i,
        data_o
	);

parameter size = 0;

input   clk_i;		  
input   rst_i;
input   select;
input   [size-1:0] data_i;
output reg  [size-1:0] data_o;
	  
always@(posedge clk_i) begin
    if(~rst_i)
        data_o <= 0;
    else
    	if(select) //flush data
            data_o <= 0;
        else 
            data_o <= data_i;

end

endmodule