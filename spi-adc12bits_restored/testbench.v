`timescale 10ns/100ps
// unité de temps = 10ns, résolution = 100ps

module testbench;

	reg clock = 1'b0;
	wire sclk_sig;
	wire cs_n_sig;
	
	reg  sdat_sig;
	wire [11:0] data_out_sig;
	wire  end_of_conversion_sig;
	wire saddr_sig;
	
	localparam period = 100;  //periode = 100 unités de temps, soit 100 x 10ns = 1us
	
	integer i;


	always begin
		#(period/2) clock = ~clock;	// génération signal d'horloge
	end
	

	spi_interface spi_inst
	(
		.clk(clock),
		.sclk(sclk_sig),
		.cs_n(cs_n_sig),
		.sdat(sdat_sig),
		.data_out(data_out_sig),
		.end_of_conversion(end_of_conversion_sig),
		.saddr(saddr_sig)
	);
	
	
	task generate_adc_value(input [11:0] v);
	// simulation des signaux en sortie dout du convertisseur A/N
		begin					
			#period	sdat_sig = v[11];	// DB11
			#period 	sdat_sig = v[10];	// DB10
			#period 	sdat_sig = v[9];	// DB9
			#period 	sdat_sig = v[8];	// DB8
			#period 	sdat_sig = v[7];	// DB7
			#period 	sdat_sig = v[6];	// DB6
			#period 	sdat_sig = v[5];	// DB5
			#period 	sdat_sig = v[4];	// DB4
			#period 	sdat_sig = v[3];	// DB3
			#period 	sdat_sig = v[2];	// DB2
			#period 	sdat_sig = v[1];	// DB1
			#period 	sdat_sig = v[0];	// DB0
			
			#period 	sdat_sig = 1'b0;
			#(3*period) ;	
		end
	endtask
	
		
	initial begin
		sdat_sig = 1'b0;
		
		#(4*period)	// temporiser pendant 4 périodes
				
		for (i = 0; i < 4096; i = i + 1) begin
			generate_adc_value(i);
		end
				
	end

endmodule
