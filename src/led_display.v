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
assign seg = 8'b1001_0000; //9;
parameter MS_MAX = 16'd4_9999; //1ms dynamic refresh;//4_9999;
reg [15:0] cnt_1ms;
reg cnt_1ms_flag;
reg [2:0] cnt_sel;
reg [2:0] sel_r;
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
            3'd0:    begin sel_r <= 3'b101; end
            3'd1:    begin sel_r <= 3'b100; end
            3'd2:    begin sel_r <= 3'b011; end
            3'd3:    begin sel_r <= 3'b010; end
            3'd4:    begin sel_r <= 3'b001; end
            3'd5:    begin sel_r <= 3'b000; end
            default: begin sel_r <= 3'b111; end
            endcase //case    
    end //else
end //always
assign sel = sel_r;

endmodule

