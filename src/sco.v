//************************************************
//  Filename      : sco.v                             
//  Author        : kingstacker                  
//  Company       : School                       
//  Email         : kingstacker_work@163.com     
//  Device        : Altera cyclone4 ep4ce6f17c8  
//  Description   : data produce logic;dout is bcd out;                             
//************************************************
module  sco (
/*i*/   input    wire              clk                 ,
        input    wire              rst_n               ,
        input    wire              key_bs              , //begin and stop;
        input    wire              key_rec             , //recording;
        input    wire              key_dis             , //display the value;
/*o*/   output   wire    [23:0]    dout        
);
parameter CNT_10MS = 19'd49_9999;
reg en_bs;//begin stop;
reg en_rec; // recording the data;
reg en_dis; //display the data;
always @(posedge clk or negedge rst_n) begin //begin & stop logic;
    if (~rst_n) begin
        en_bs <= 0;
    end //if
    else begin
        en_bs <= (key_bs) ? ~en_bs : en_bs;    
    end //else
end //always
always @(posedge clk or negedge rst_n) begin //recording logic;
    if (~rst_n) begin
        en_rec <= 0;
    end //if
    else begin
        en_rec <= (en_bs && key_rec) ? 1'b1 : 1'b0;    
    end //else
end //always
always @(posedge clk or negedge rst_n) begin //display logic;
    if (~rst_n) begin
        en_dis <= 0;
    end //if
    else begin
        en_dis <= (~en_bs && key_dis) ? 1'b1 : 1'b0;    
    end //else
end //always
reg [18:0] cnt_10ms;
reg flag_10ms; //0.01s;
always @(posedge clk or negedge rst_n) begin  //cnt_10ms value change logic;
    if (~rst_n) begin
        cnt_10ms <= 0;
    end //if
    else begin
        cnt_10ms <= (cnt_10ms == CNT_10MS) ? 19'd0 : cnt_10ms + 1'b1;    
    end //else
end //always
always @(posedge clk or negedge rst_n) begin //produce one period high signal;
    if (~rst_n) begin
        flag_10ms <= 1'b0;
    end //if
    else begin
        flag_10ms <= (cnt_10ms == CNT_10MS) ? 1'b1 : 1'b0;    
    end //else
end //always
reg [3:0] cnt_0; //lsb-msb => 0-5;
reg [3:0] cnt_1;
reg [3:0] cnt_2;
reg [3:0] cnt_3;
reg [3:0] cnt_4;
reg [3:0] cnt_5;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt_0 <= 0;
    end //if
    else begin
        cnt_0 <= (cnt_0 == 4'd9 && flag_10ms) ? 4'd0 : (en_bs && flag_10ms) ? cnt_0 + 1'b1 : cnt_0;    
    end //else
end //always
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt_1 <= 0;
    end //if
    else begin
        cnt_1 <= (cnt_1 == 4'd9 && cnt_0 == 4'd9 && flag_10ms) ? 4'd0 : (cnt_0 == 4'd9 && flag_10ms) ? cnt_1 + 1'b1 : cnt_1;    
    end //else
end //always
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt_2 <= 0;
    end //if
    else begin
        cnt_2 <= (cnt_2 == 4'd9 && cnt_1 == 4'd9 && cnt_0 == 4'd9 && flag_10ms) ? 4'd0 : (cnt_1 == 4'd9 && cnt_0 == 4'd9 && flag_10ms) ? cnt_2 + 1'b1 : cnt_2;    
    end //else
end //always
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt_3 <= 0;
    end //if
    else begin
        cnt_3 <= (cnt_3 == 4'd5 && cnt_2 == 4'd9 && cnt_1 == 4'd9 && cnt_0 == 4'd9 && flag_10ms) ? 4'd0 : (cnt_2 == 4'd9 && cnt_1 == 4'd9 && cnt_0 == 4'd9 && flag_10ms) ? cnt_3 + 1'b1 : cnt_3;    
    end //else
end //always
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt_4 <= 0;
    end //if
    else begin
        cnt_4 <= (cnt_4 == 4'd9 && cnt_3 == 4'd5 && cnt_2 == 4'd9 && cnt_1 == 4'd9 && cnt_0 == 4'd9 && flag_10ms) ? 4'd0 : (cnt_3 == 4'd5 && cnt_2 == 4'd9 && cnt_1 == 4'd9 && cnt_0 == 4'd9 && flag_10ms) ? cnt_4 + 1'b1 : cnt_4;    
    end //else
end //always
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt_5 <= 0;
    end //if
    else begin
        cnt_5 <= (cnt_5 == 4'd5 && cnt_4 == 4'd9 && cnt_3 == 4'd5 && cnt_2 == 4'd9 && cnt_1 == 4'd9 && cnt_0 == 4'd9 && flag_10ms) ? 4'd0 : (cnt_4 == 4'd9 && cnt_3 == 4'd5 && cnt_2 == 4'd9 && cnt_1 == 4'd9 && cnt_0 == 4'd9 && flag_10ms) ? cnt_5 + 1'b1 : cnt_5;    
    end //else
end //always

reg [23:0] data_rec0; //data recording;
reg [23:0] data_rec1;
reg [23:0] data_rec2;
reg [1:0]  cnt_rec;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt_rec <= 0;
    end //if
    else begin
        cnt_rec <= (cnt_rec == 2'd2 && en_rec ) ? 2'd0 : (en_rec) ? cnt_rec + 1'b1 : cnt_rec;     //point errro;
    end //else
end //always
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        data_rec0 <= 24'hffffff;
        data_rec1 <= 24'hffffff;
        data_rec2 <= 24'hffffff;
    end //if
    else begin
        case (cnt_rec)
                2'd0: begin data_rec0 <= (en_rec) ? {cnt_5,cnt_4,cnt_3,cnt_2,cnt_1,cnt_0} : data_rec0; end
                2'd1: begin data_rec1 <= (en_rec) ? {cnt_5,cnt_4,cnt_3,cnt_2,cnt_1,cnt_0} : data_rec1; end
                2'd2: begin data_rec2 <= (en_rec) ? {cnt_5,cnt_4,cnt_3,cnt_2,cnt_1,cnt_0} : data_rec2; end
                default: ;
            endcase //case    
    end //else
end //always

reg [23:0] data_r;
reg [1:0]  cnt_dis;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt_dis <= 0;
    end //if
    else begin
        cnt_dis <= (en_bs) ? 2'd0 : (en_dis) ? cnt_dis + 1'b1 : cnt_dis;   //point error; 
    end //else
end //always
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        data_r <= 24'hffffff;
    end //if
    else begin
        if (en_bs) begin
           data_r <= {cnt_5,cnt_4,cnt_3,cnt_2,cnt_1,cnt_0}; //display;
        end 
        else begin
           case (cnt_dis)
                   2'd0: begin data_r <= {cnt_5,cnt_4,cnt_3,cnt_2,cnt_1,cnt_0}; end
                   2'd1: begin data_r <= data_rec0; end    //display recording value one;
                   2'd2: begin data_r <= data_rec1; end    //display recording value two;
                   2'd3: begin data_r <= data_rec2; end    //display recording value three;
                   default:;
               endcase //case    
        end   
    end //else
end //always
assign dout = data_r;

endmodule



