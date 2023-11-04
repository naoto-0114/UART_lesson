////////////////////////////////////////////////////////////////
// UART module                                                //
// TOP.v                                                      //
// UTF-8                                                      //
// hiratsuka naoto                                            //
// 2020.11.4                                                  //
// Rev0.1 new                                                 //
////////////////////////////////////////////////////////////////

module TOP #(
	parameter P_CLK_FRQ = 48_000_000,
	parameter P_BAURATE = 9600
	)(
	input  wire        CLK      ,
	input  wire        RESET    ,
	output wire        UART_TX  ,
	output wire [7:0]  LED
	);

	// 内部信号宣言
	wire         w_sec1pos      ;
	wire  [7:0]  w_data         ;

	// 内部接続
	assign LED = w_data ;

	// インスタンス
	SEC1GEN #(
		.P_CLK_FRQ (P_CLK_FRQ    )
		) u_sec1gen (
		.CLK       (CLK          ),  // i:クロック
		.RESET     (RESET        ),  // i:リセット
		.SEC1POS   (w_sec1pos    )   // o:1秒カウンタフラグ
		);

	DATA_GEN u_data_gen (
		.CLK       (CLK          ),  // i:クロック
		.RESET     (RESET        ),  // i:リセット
		.SEC1POS   (w_sec1pos    ),  // i:1秒カウンタフラグ
		.DATA      (w_data       )   // o:送出データ [7:0]
		);

	UART_SEND #(
		.P_CLK_FRQ (P_CLK_FRQ    ),
		.P_BAURATE (P_BAURATE    )
		) u_uart_send (
		.CLK       (CLK          ),  // i:クロック
		.RESET     (RESET        ),  // i:リセット
		.SEC1POS   (w_sec1pos    ),  // i:1秒カウンタフラグ
		.DATA      (w_data       ),  // i:送出データ [7:0]
		.UART_TX   (UART_TX      )   // o:UART送信端子
		);

endmodule