`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/24 01:03:29
// Design Name: 
// Module Name: ButtonVibration
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


module ButtonVibration (
    input clk,
    input rst,
    input buttoncs,
    input  button,
    output reg  buttonout
);

/*
    reg[19:0] cnt0;
    
    
    reg flag0;
    
 //   wire buttonEnable;
    wire bclk;
    
    reg [19:0] count;                         // ??????
    //wire button_clk;
     
    always @ (posedge clk)
      if (rst )
        count <= 0;
      else 
        count <= count + 1'b1;
        
    assign bclk = count[19]; 
    
    assign buttonout=flag0;
    
 //   assign buttonEnable = button[4] || button[3] || button[2] || button[1] || button[0]; //ֻҪ���ⰴ�������£���Ӧ�İ���������????
    
    always@(posedge bclk)
    begin
        if(rst)
        begin
            cnt0 = 1'b0;
            flag0 = 1'b0;
            end
        else begin
               if(button && buttoncs)
                      cnt0=cnt0+1;
                      
                      if(cnt0== 20'd20)
                      begin
                          flag0=1;
                          cnt0=20'd0;
                          end
                          else 
                          flag0=0;
              end
    end
    **/
    reg [7:0] cnt;
    parameter p = 40;
    
    always @(posedge clk, negedge rst)
    begin
    if(!rst)
      begin
      buttonout <= 0;
      cnt <= 0;
      end
    else 
      begin
      if(button)
        begin
        if(cnt == (p >> 1) - 1)
          begin
          buttonout <= 1;
          cnt <= 0;
          end
        else
          begin
          cnt <= cnt + 1;
          end
        end  
      else
        begin
        buttonout <= 0;
        cnt <= 0;
        end
      end
    end

      
endmodule