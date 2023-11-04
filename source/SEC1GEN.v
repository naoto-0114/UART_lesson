////////////////////////////////////////////////////////////////
// UART module                                                //
// SEC1GEN.v                                                  //
// UTF-8                                                      //
// hiratsuka naoto                                            //
// 2020.11.4                                                  //
// Rev0.1 new                                                 //
////////////////////////////////////////////////////////////////

module SEC1GEN #(
	parameter          P_CLK_FRQ = 48_000_000
	)(
	input   wire       CLK       ,
	input   wire       RESET     ,
	output  wire       SEC1POS   
	);

	// �?部信号宣�?
	reg   [25:0]   r_cnt_1sec   ;
	
	// 1秒フラグ生�?�回路
	always @(posedge CLK or negedge RESET ) begin
		if (~RESET) begin
			r_cnt_1sec <= 26'd0 ;
		end else begin
			if (r_cnt_1sec == (P_CLK_FRQ - 1)) begin
				r_cnt_1sec <= 26'd0 ;
			end else begin
				r_cnt_1sec <= r_cnt_1sec + 26'd1 ;
			end
		end
	end

	assign SEC1POS = (r_cnt_1sec == (P_CLK_FRQ - 1)) ? 1'd1 : 1'd0 ;

endmodule