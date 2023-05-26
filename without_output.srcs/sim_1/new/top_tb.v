`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/24 10:59:02
// Design Name: 
// Module Name: top_tb
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


module top_tb( );
reg clk;
  reg fpga_rst;
  reg [23:0] switches;
  wire [23:0] leds;
  reg start_pg;
  reg rx;
  wire tx;
  reg button;
  wire [7:0] DIG;
  wire [7:0] Y;

  CPU_TOP uut (
    .clk(clk),
    .fpga_rst(fpga_rst),
    .switches(switches),
    .leds(leds),
    .start_pg(start_pg),
    .rx(rx),
    .tx(tx),
    .button(button),
    .DIG(DIG),
    .Y(Y)
  );

  initial begin
    clk = 0;
    fpga_rst = 0;
    switches = 0;
    start_pg = 0;
    rx = 0;
    button = 0;
#10 fpga_rst = 1'b1;
#10000 fpga_rst = 1'b0;
#10000
switches  = 24'b0000;

    //确定选择测试场景
    #10000;
     button = 1;
     #10000;
      button = 0;
      #10000
      switches = 24'b1111;
    #10000;
    //确定输入数据
    button = 1;
    #10000;
    button = 0;
    #10000
    
    //结束
    button = 1;
    #100000
    button = 0;
    
 

       
   

    // End simulation
    #10;
    $finish;
  end

  always #5 clk = ~clk;
endmodule
