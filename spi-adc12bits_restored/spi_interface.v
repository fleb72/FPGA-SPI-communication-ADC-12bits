module spi_interface
	#( 
		parameter [2:0] ADD = 3'b101	// <ADD2><ADD1><ADD0> = 101, soit Analog Input 5
	)

	(
		input clk,							// horloge jusqu'à 3,2MHz maxi
		input sdat,							// ADC Digital Data Output
		
		output reg saddr,					// ADC Digital Data Input
		output wire sclk,					// ADC Digital Clock Input
		output wire cs_n,					// ADC Chip Select
		output wire [11:0] data_out,	// Résultat de la conversion 12 bits
		output wire end_of_conversion	// Impulsion synchro. End Of Conversion
	);
	
	
// ---------------------------------------------------------------------------

	reg [3:0] counter;			// compteur 4 bits interne
	reg cs = 1'b0;
		
	initial begin	// non synthétisable, pour la simulation uniquement
		counter = 0;
	end
	
	assign cs_n = ~cs;
	
	assign sclk = cs_n ? 1'b1 : clk;


	always @(negedge clk) begin
		if (counter == 4'd1) begin
			cs <= 1'b1;	// active Chip Select
		end
	end


	always @(posedge clk) begin	
		counter <= counter + 4'd1;
	end

	
	always @(negedge clk) begin
		saddr <= 1'b0;
		case(counter)
			3: begin
					saddr <= ADD[2];
				end
			4: begin
					saddr <= ADD[1];
				end			
			5: begin
					saddr <= ADD[0];
				end			
		endcase
	end

	wire dout_available; 	
	assign dout_available = ((counter >= 5 ) || (counter == 0)) && (~cs_n);
	
	assign end_of_conversion = (counter == 4'd1) && (~cs_n);
	
	
	reg [11:0] data_temp;	// donnée temporaire 12bits
	always @(posedge clk) begin
		if (dout_available) 
				data_temp <= {data_temp[10:0], sdat};	
	end
	
	assign data_out = end_of_conversion ? data_temp : data_out;
	
endmodule
