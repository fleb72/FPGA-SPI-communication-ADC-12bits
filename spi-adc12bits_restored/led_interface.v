module led_interface
	(
		input clk,
		input new_data,
		input wire [11:0] data,
		output reg [7:0] led_out	
	);
	
	always @(posedge clk) begin
		if (new_data) begin
			led_out[0] <= (data >= 256);
			led_out[1] <= (data >= 768);
			led_out[2] <= (data >= 1280);
			led_out[3] <= (data >= 1792);
			led_out[4] <= (data >= 2304);
			led_out[5] <= (data >= 2816);
			led_out[6] <= (data >= 3328);
			led_out[7] <= (data >= 3840);
		end																			
	end
	
endmodule
	