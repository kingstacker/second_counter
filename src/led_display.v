//************************************************
//  Filename      : led_display.v                             
//  Author        : kingstacker                  
//  Company       : School                       
//  Email         : kingstacker_work@163.com     
//  Device        : Altera cyclone4 ep4ce6f17c8  
//  Description   :                              
//************************************************
module  led_display (
/*i*/   input    wire              clk              ,
        input    wire              rst_n            ,
        input    wire    [47:0]    din              ,  //data from sco model;
/*o*/   output   wire    [2:0]     sel              ,  //38 decoder;
        output   wire    [7:0]     seg                 
);
parameter MS_MAX = 16'd4_9999; //1ms dynamic refresh;//4_9999;
reg [15:0] cnt_1ms;
reg cnt_1ms_flag;
reg [2:0] cnt_sel;
reg [2:0] sel_r;
reg [6:0] seg_r;
reg [7:0] seg_sel;
wire dp;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt_1ms <= 0;
    end //if
    else begin
        cnt_1ms <= (cnt_1ms == MS_MAX) ? 16'd0 : cnt_1ms + 1'b1;    
    end //else
end //always
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt_1ms_flag <= 0;
    end //if
    else begin
        cnt_1ms_flag <= (cnt_1ms == MS_MAX) ? 1'b1 : 1'b0;    
    end //else
end //always
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt_sel <= 0;
    end //if
    else begin
        if (cnt_sel == 3'd6) begin
            cnt_sel <= 0;
        end    
        else begin
            cnt_sel <= (cnt_1ms_flag == 1'b1) ? cnt_sel + 1'b1 : cnt_sel;
        end
    end //else
end //always
//dynamic refresh;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sel_r <= 3'b111;
    end //if
    else begin
        case (cnt_sel) 
            3'd0:    begin sel_r <= 3'b101;seg_sel <= din[7:0];   end
            3'd1:    begin sel_r <= 3'b100;seg_sel <= din[15:8];  end
            3'd2:    begin sel_r <= 3'b011;seg_sel <= din[23:16]; end
            3'd3:    begin sel_r <= 3'b010;seg_sel <= din[31:24]; end
            3'd4:    begin sel_r <= 3'b001;seg_sel <= din[39:32]; end
            3'd5:    begin sel_r <= 3'b000;seg_sel <= din[47:40]; end
            default: begin sel_r <= 3'b111;                       end
            endcase //case    
    end //else
end //always
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        seg_r <= 7'b111_1111;
    end //if
    else begin
        case (seg_sel)
            8'd0: begin seg_r <= 7'b100_0000; end //0; 
            8'd1: begin seg_r <= 7'b111_1001; end //1; 
            8'd2: begin seg_r <= 7'b010_0100; end //2; 
            8'd3: begin seg_r <= 7'b011_0000; end //3; 
            8'd4: begin seg_r <= 7'b001_1001; end //4; 
            8'd5: begin seg_r <= 7'b001_0010; end //5; 
            8'd6: begin seg_r <= 7'b000_0010; end //6; 
            8'd7: begin seg_r <= 7'b111_1000; end //7; 
            8'd8: begin seg_r <= 7'b000_0000; end //8; 
            8'd9: begin seg_r <= 7'b001_0000; end //9; 
            default: begin seg_r <= 7'b111_1111; end //x;
            endcase //case    
    end //else
end //always
assign dp = !(cnt_sel == 3'd2 || cnt_sel == 3'd4);  //dp logic produce case;
assign sel = sel_r;
assign seg = {dp,seg_r};
endmodule

