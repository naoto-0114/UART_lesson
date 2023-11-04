////////////////////////////////////////////////////////////////
// UART module                                                //
// DATA_GEN.v                                                 //
// UTF-8                                                      //
// hiratsuka naoto                                            //
// 2020.11.4                                                  //
// Rev0.1 new                                                 //
////////////////////////////////////////////////////////////////

module DATA_GEN (
	input   wire         CLK       ,
	input   wire         RESET     ,
	input   wire         SEC1POS   ,
	output  wire  [7:0]  DATA   
	);

	// 内部信号宣言
	reg   [7:0]   r_data   ;
	
	// データカウントアップ回路
	always @(posedge CLK or negedge RESET ) begin
		if (~RESET) begin
			r_data <= 8'd0 ;
		end else begin
			if (~SEC1POS) begin
				r_data <= r_data ;
			end else begin
				if (r_data == 8'hff ) begin
					r_data <= 8'd0 ;
        		end else begin
					r_data <= r_data + 8'd1 ;
    			end
			end
		end
	end

	assign DATA = r_data ;

endmodule