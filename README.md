# second_counter
数字秒表的FPGA实现

主要功能，按键触发：秒表开始，暂停，记录，回显。一共四个按键，第一个按键控制全局复位，第二个按键控制秒表的开始与暂停，第三个按键控制秒表在运行中按下记录，第四个按键控制秒表在暂停的时候，记录的数据可以按一下则顺序回显一个数据，一共三个数据。

秒表可以从00:00:00 -- 59:59:99 ， 6位数码管
单时钟域。
主要模块：按键消抖模块：debounce
         秒表数据产生模块：sco
         数码管动态显示模块：led_display
