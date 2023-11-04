////////////////////////////////////////////////////////////////
// UART module                                                //
// UART_SEND.v                                                //
// UTF-8                                                      //
// hiratsuka naoto                                            //
// 2020.11.4                                                  //
// Rev0.1 new                                                 //
////////////////////////////////////////////////////////////////

module UART_SEND #(
	parameter          P_CLK_FRQ = 48_000_000,
	parameter          P_BAURATE = 9600
	)(
	input   wire         CLK       ,
	input   wire         RESET     ,
	input   wire         SEC1POS   ,
	input   wire  [7:0]  DATA      ,
	output  wire         UART_TX      
	);

	// �?部信号宣�?
  	reg   [15:0]  r_uart_cnt     ;
  	reg           r_uart_flg     ;
	reg   [3:0]   r_bit_idx      ;
	reg   [9:0]   r_tx_shift_reg ;

	// 送信タイミング生�?�回路
	always @(posedge CLK or negedge RESET ) begin
		if (~RESET) begin
			r_uart_cnt <= 16'd0 ;
      		r_uart_flg <= 1'b0 ;
		end else begin
			if (SEC1POS) begin
				r_uart_cnt <= 16'd0 ;
				r_uart_flg <= 1'b0 ;
			end else begin
				if (r_uart_cnt == (( P_CLK_FRQ / P_BAURATE ) - 1 )) begin
					r_uart_cnt <= 16'd0 ;
					r_uart_flg <= 1'b1 ;
				end else begin
					r_uart_cnt <= r_uart_cnt + 16'd1 ;
					r_uart_flg <= 1'b0 ;
				end
			end
		end
	end

	// �?ータ送�?�回路
	always @(posedge CLK or negedge RESET ) begin
		if (~RESET) begin
      		r_tx_shift_reg <= 10'd0 ;
		end else begin
			if (SEC1POS) begin
				r_tx_shift_reg <= {1'b1, DATA, 1'b0 } ;
			end else begin
				if (r_uart_flg) begin
					r_tx_shift_reg <= {1'b1, r_tx_shift_reg[9:1] } ;
				end else begin
					r_tx_shift_reg <= r_tx_shift_reg ;
				end
			end
		end
	end

	assign UART_TX = r_tx_shift_reg[0] ;

endmodule