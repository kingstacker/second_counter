//************************************************
//  Filename      : second_counter.v                             
//  Author        : kingstacker                  
//  Company       : School                       
//  Email         : kingstacker_work@163.com     
//  Device        : Altera cyclone4 ep4ce6f17c8  
//  Description   : second_counter;key0:stop and begin;
//                  key1:recording;
//                  key2:order print;                             
//************************************************
module  second_counter_top (
/*i*/   input    wire             clk                 ,
        input    wire             rst_n               ,
        input    wire             key_bs              , //stop&begin;
        input    wire             key_rec             , //recording key;
        input    wire             key_dis             , //order print;
/*o*/   output   wire    [2:0]    sel                 ,                   
/*o*/   output   wire    [7:0]    seg                  
);
wire        key_bs_o;
wire        key_rec_o;
wire        key_dis_o;
wire [23:0] dout;
//debounce inst;
debounce  debounce_u1( 
    .clk                 (clk),
    .rst_n               (rst_n),
    .key_i               (key_bs),
    .key_o               (key_bs_o)
);
//debounce inst;
debounce  debounce_u2( 
    .clk                 (clk),
    .rst_n               (rst_n),
    .key_i               (key_rec),
    .key_o               (key_rec_o)
);//debounce inst;
debounce  debounce_u3( 
    .clk                 (clk),
    .rst_n               (rst_n),
    .key_i               (key_dis),
    .key_o               (key_dis_o)
);

//sco inst;
sco  sco_u1( 
    .clk                 (clk),
    .rst_n               (rst_n),
    .key_bs              (key_bs_o),
    .key_rec             (key_rec_o),
    .key_dis             (key_dis_o),
    .dout                (dout)
);

//led_display inst;
led_display  led_display_u1( 
    .clk                 (clk),
    .rst_n               (rst_n),
    .din                 (dout),
    .sel                 (sel),
    .seg                 (seg)
);

endmodule