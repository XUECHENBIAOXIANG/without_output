`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/20 22:17:29
// Design Name: 
// Module Name: dmemory32
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


module dmemory32(ram_clk_i, ram_wen_i, ram_adr_i, ram_dat_i, ram_dat_o, upg_rst_i, upg_clk_i, upg_wen_i, upg_adr_i, upg_dat_i, upg_done_i );

//    input clock, memWrite;  //memWrite ????controller???1'b1???????data-memory??��????

//    input [31:0] address;   //address ????????��

//    input [31:0] writeData; //writeData ????data-memory??��???????

//    output[31:0] readData;  //writeData ????data-memory?��?????????
//    wire clk;
//    assign clk = !clock;

    input ram_clk_i; // from CPU top 
    input ram_wen_i; // from Controller 
    input [13:0] ram_adr_i; // from alu_result of ALU 
    input [31:0] ram_dat_i; // from read_data_2 of Decoder 
    output [31:0] ram_dat_o; // the data read from data-ram 
    
    // UART Programmer Pinouts 
    input upg_rst_i; // UPG reset (Active High) 
    input upg_clk_i; // UPG ram_clk_i (10MHz) 
    input upg_wen_i; // UPG write enable 
    input [13:0] upg_adr_i; // UPG write address 
    input [31:0] upg_dat_i; // UPG write data 
    input upg_done_i; // 1 if programming is finished
    
//RAM data_ram(
//     .clka(clk), 
//     .wea(memWrite), // input wire [0 : 0] wea
//     .addra(address[15:2]), // base: 4byte
//     .dina(writeData),
//     .douta(readData)
//);
   
   wire ram_clk = !ram_clk_i; 
   /* CPU work on normal mode when kickOff is 1. CPU work on Uart communicate mode when kickOff is 0.*/
   wire kickOff = upg_rst_i | (~upg_rst_i & upg_done_i); 
   RAM ram ( 
       .clka (kickOff ? ram_clk : upg_clk_i), 
       .wea (kickOff ? ram_wen_i : upg_wen_i),
       .addra (kickOff ? ram_adr_i : upg_adr_i), 
       .dina (kickOff ? ram_dat_i : upg_dat_i), 
       .douta (ram_dat_o) 
   );
endmodule

