//Subject:     CO project 5 - IF_Write
//--------------------------------------------------------------------------------

module IF_Write_Pipe_Reg(
    clk_i,
    rst_i,
    select_write,
    select_flush,
    data_i,
    data_o
	);

parameter size = 0;

input   clk_i;		  
input   rst_i;
input   select_write;
input   select_flush;
input   [size-1:0] data_i;
output reg  [size-1:0] data_o;
	  
always@(posedge clk_i) begin
    if(~rst_i)
        data_o <= 0;
    else
        if(select_flush)
            data_o <= 0;
    	else if(select_write != 1'd0)
        	data_o <= data_i;
end

endmodule