//************************************************
//  Filename      : led_display.v                             
//  Author        : kingstacker                  
//  Company       : School                       
//  Email         : kingstacker_work@163.com     
//  Device        : Altera cyclone4 ep4ce6f17c8  
//  Description   :on board ok; one clk domain;input din is bcd ;                           
//************************************************
module  led_display (
/*i*/   input    wire              clk              ,
        input    wire              rst_n            ,
        input    wire    [23:0]    din              ,  //data from sco model;
/*o*/   output   wire    [2:0]     sel              ,  //38 decoder;
        output   wire    [7:0]     seg                 //segement;      
);
parameter MS_MAX = 17'd4_9999; //1ms dynamic refresh;//4_9999;
reg          flag_1ms;
reg  [16:0]  cnt_1ms;
reg  [2:0]   sel_r;
reg  [6:0]   seg_r;
reg  [3:0]   seg_sel;
reg  [2:0]   cnt_sel;
wire         dp;  
always @(posedge clk or negedge rst_n) begin   //control cnt_1ms value;
    if (~rst_n) begin
        cnt_1ms <= 0;
    end //if
    else begin
        cnt_1ms <= (cnt_1ms == MS_MAX) ? 16'd0 : cnt_1ms + 1'b1;    
    end //else
end //always
always @(posedge clk or negedge rst_n) begin //produce the flag_1ms high level;
    if (~rst_n) begin
        flag_1ms <= 1'b0;
    end //if
    else begin
        flag_1ms <= (cnt_1ms == MS_MAX) ? 1'b1 : 1'b0;    
    end //else
end //always
always @(posedge clk or negedge rst_n) begin //cnt sel value control;
    if (~rst_n) begin
        cnt_sel <= 0;
    end //if
    else begin
        cnt_sel <= (cnt_sel == 3'd5 && flag_1ms) ? 3'd0 : (flag_1ms) ? cnt_sel + 1'b1 : cnt_sel;   
    end //else
end //always
always @(*) begin          //sel logic exchange;
        case (cnt_sel)
            3'd0: begin sel_r = 3'b101;seg_sel = din[3:0];   end
            3'd1: begin sel_r = 3'b100;seg_sel = din[7:4];   end
            3'd2: begin sel_r = 3'b011;seg_sel = din[11:8];  end
            3'd3: begin sel_r = 3'b010;seg_sel = din[15:12]; end
            3'd4: begin sel_r = 3'b001;seg_sel = din[19:16]; end
            3'd5: begin sel_r = 3'b000;seg_sel = din[23:20]; end
            default: begin sel_r = 3'b111;seg_sel = 4'd10;   end 
        endcase //case   
end //always
always @(*) begin         //display coder;
        case (seg_sel)
            4'd0: begin seg_r = 7'b100_0000;    end //0; 
            4'd1: begin seg_r = 7'b111_1001;    end //1; 
            4'd2: begin seg_r = 7'b010_0100;    end //2; 
            4'd3: begin seg_r = 7'b011_0000;    end //3; 
            4'd4: begin seg_r = 7'b001_1001;    end //4; 
            4'd5: begin seg_r = 7'b001_0010;    end //5; 
            4'd6: begin seg_r = 7'b000_0010;    end //6; 
            4'd7: begin seg_r = 7'b111_1000;    end //7; 
            4'd8: begin seg_r = 7'b000_0000;    end //8; 
            4'd9: begin seg_r = 7'b001_0000;    end //9; 
            default: begin seg_r = 7'b100_0000; end //x;
            endcase //case    
end //always

assign dp = !(cnt_sel == 3'd2 || cnt_sel == 3'd4);  //dp produce logic;
assign seg = {dp,seg_r};
assign sel = sel_r;

endmodule

