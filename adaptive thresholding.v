`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/01/2023 10:09:05 PM
// Design Name: 
// Module Name: conv
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module conv(
input        i_clk,
input [71:0] i_pixel_data,
input        i_pixel_data_valid,
output reg [7:0] o_convolved_data,
output reg   o_convolved_data_valid
    );
 
 

integer i; 
reg lR[8:0];
reg compDataValid;
reg convolved_data_valid;
reg [7:0] u1 = 8'b01100100;
reg [7:0] u2 = 8'b01111000;
reg [7:0] compu1[8:0];
reg [7:0] compu2[8:0];
reg weightUpdateValid;
wire [7:0]threshold_value;



//logic for comparing weights with incoming pixell value
always @(posedge i_clk)
begin
    for(i=0;i<9;i=i+1)
    begin
        compu1[i] <= i_pixel_data[i*8+:8] - u1;
        compu2[i] <= i_pixel_data[i*8+:8] - u2;
	lR[i]     <= (256 - i_pixel_data[i*8+:8])/256;
    end
    compDataValid <= i_pixel_data_valid;
    
end

always @(posedge i_clk)
begin
    for(i=0;i<9;i=i+1)
    begin
        if(compu1[i]<compu2[i])
            u1 <= u1 + (lR * compu1[i]);
        else if(compu1[i]>compu2[i])
            u2 <= u2 + (lR * compu2[i]);
    end
    weightUpdateDataValid <= compDataValid ;
end




assign threshold_value = (u1+u2)/2;


    
always @(posedge i_clk)
begin
    for(i=0;i<9;i=i+1)
    begin
    if(i_pixel_data[i*8+:8] >= threshold_value )
        o_convolved_data <= 8'hff;
    else
        o_convolved_data <= 8'h00;
    end
    o_convolved_data_valid <= weightUpdateDataValid 
end
    
endmodule