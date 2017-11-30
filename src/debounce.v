//************************************************
//  Filename      : debounce.v                             
//  Author        : kingstacker                  
//  Company       : School                       
//  Email         : kingstacker_work@163.com     
//  Device        : Altera cyclone4 ep4ce6f17c8  
//  Description   : when the key is pressed ,porduce 1 period clk high;                            
//************************************************
module  debounce (  //use shift reg logic;
/*i*/   input    wire    clk          ,
        input    wire    rst_n        ,
        input    wire    key_i        ,
/*o*/   output   wire    key_o     
);
parameter CLK_MAX = 19'd49_9999; //0.01s;
reg [18:0] cnt;
reg clk_en;
reg key_o_r;
always @(posedge clk or negedge rst_n) begin //control cnt value;
    if (~rst_n) begin
        cnt <= 0;
    end //if
    else begin
        cnt <= (cnt == CLK_MAX) ? 19'd0 : cnt + 1'b1;    
    end //else
end //always
always @(posedge clk or negedge rst_n) begin //produce clk_en;
    if (~rst_n) begin
        clk_en <= 1'b0;
    end //if
    else begin
        clk_en <= (cnt == CLK_MAX) ? 1'b1 : 1'b0;    
    end //else
end //always
reg [7:0] shift_val;
always @(posedge clk or negedge rst_n) begin //shift logic;
    if (~rst_n) begin
        shift_val <= 8'hff;
    end //if
    else begin
        shift_val <= (clk_en) ? {shift_val[6:0],key_i} : shift_val;    
    end //else
end //always
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        key_o_r <= 1'b0;
    end //if
    else begin
        if (shift_val == 8'b1000_0000 && clk_en) begin  //check key pressed negedge;
        	key_o_r <= 1'b1;
        end    
        else begin
        	key_o_r <= 1'b0;
        end
    end //else
end //always
assign key_o = key_o_r;

endmodule



