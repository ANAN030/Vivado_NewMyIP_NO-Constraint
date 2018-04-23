# Vivado_NewMyIP
這次會用Vivado做一個自己的IP,並跑模擬測試IP功能是否正確,而IP功能會做一個簡單的8-bit加法器,
最後並搭配AXI-GPIO和LED一起實做.

# 影片
未完成......

# 建立自己的IP
步驟 1
> 創建一個新的專案,要做為測試自己IP功能用.<br>
> 假如不會創建的話可以到我之前做的範例Vivado部份的步驟1到步驟6中看到,傳送門如下：
> https://github.com/ANAN030/Vivado_Basic
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/01.png "01")

步驟 2
> 新增一個Verilog,來寫IP要做什麼功能.
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/02.png "02")

步驟 3
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/03.png "03")

步驟 4
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/04.png "04")

步驟 5
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/05.png "05")

步驟 6
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/06.png "06")

步驟 7
> 加法器就用兩個要計算的A和B,及一個觸發CLK和運算過後的輸出S組成,如下圖：
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/07-1.png "07")
> <br>因為要做8-bit的加法器,所以輸入的A和B會設定成8-bit,不過要注意輸出的部份,那就是S會設定為9-bit,那是因為會有溢位的問題存在,下面我簡單舉個例子,讓各位更清楚溢位是什麼意思.<br>
> ```
> 例.
>
>      1101 0001   ---> 209
>  +   0110 0100   ---> 100
> ————————————————
>    1 0011 0101   ---> 9-bit的話值會是309,要是8-bit的話值就變成53
>    ↓
>   溢位
> ```
> 參數設定如下：
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/07.png "07")

步驟 8
> 開始設計自己的IP功能,這邊我就不用邏輯閘的方式去設計加法器了,就直接使用Vivado的加法,假如你需要其它功能,再自己設計就好.
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/08.png "08")
> 程式碼如下：
> ```sv
> module MyIP_Adder8bit(
>     input CLK,
>     input [7:0] A,
>     input [7:0] B,
>     output reg [8:0] S
>     );
>     
>     always @ (posedge CLK) begin
>         S = A + B;
>     end
>     
> endmodule
> ```
> 一開始不會有reg,要自行加上,因為輸出在定義時要給個記憶體,而最後是否要生記憶體時,就由生成工具去判斷要不要有記憶體.
> ```sv
> output reg [8:0] S
> ```
> "posedge CLK"代表CLK在正緣時,觸發區塊內的動作,也就是俗稱的正緣觸發.
> ```sv
> always @ (posedge CLK) begin
>     .
>     .
>     .
> end
> ```
> 這邊的"+"會在合成時,由合成工具生成加法的電路,可以減少我們設計電路的複雜度,不過也是可以用自己設計加法器電路.
> ```sv
> S = A + B;
> ```

步驟 9
> 設計完IP功能後,接下來就是要建立模擬測試用的檔案.<br>
> （假如不想跑行為模式模擬測試功能的話,可以直接跳到步驟19,直接開始包裝成IP）
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/13.png "13")

步驟 10
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/14.png "14")

步驟 11
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/15.png "15")

步驟 12
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/16.png "16")

步驟 13
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/17.png "17")

步驟 14
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/18.png "18")

步驟 15
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/19.png "19")

步驟 16
> 這邊就可以開始編寫,行為模擬測試用的程式.
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/20.png "20")
> 程式碼如下：
> ```sv
> module MyIP_Adder8bit_tb();
>
>     reg CLK_tb;
>     reg [7:0] A_tb;
>     reg [7:0] B_tb;
>     wire [8:0] S_tb;
>    
>     MyIP_Adder8bit U1(.CLK(CLK_tb), .A(A_tb), .B(B_tb), .S(S_tb));
>    
>     initial begin
>         CLK_tb = 0;
>         A_tb = 0;
>         B_tb = 0;
>        
>         #35;
>        
>         A_tb = 3;
>         B_tb = 4;
>         
>         #26;
>                
>         A_tb = 7;
>         B_tb = 2;
>
>     end
>     
>     always #10 CLK_tb <= ~CLK_tb;
>
> endmodule
> ```
> 需要記憶空間用來紀錄測試用的的資料.
> ```sv
> reg CLK_tb;
> reg [7:0] A_tb;
> reg [7:0] B_tb;
> wire [8:0] S_tb;
> ```
> 把剛剛寫完的功能,與測試程式連接在一起.
> ```sv
> MyIP_Adder8bit U1(.CLK(CLK_tb), .A(A_tb), .B(B_tb), .S(S_tb));
> ```
> 用"initial"控制模擬測試用的輸入數據.
> ```sv
> initial begin
> .
> .
> .
> end
> ```
> 要先把所有的輸入做初始化的動作,不然模擬時,一開始都會是亂碼(X),再來"#35"功能是等待35個時間單位,才會開始執行下一個程式.
> ```sv
> CLK_tb = 0;
> A_tb = 0;
> B_tb = 0;
>
> #35;
>      
> A_tb = 3;
> B_tb = 4;
>       
> #26;
>              
> A_tb = 7;
> B_tb = 2;
> ```
> 每10個時間單位讓CLK反向,模擬出時脈的功能.
> ```sv
> always #10 CLK_tb <= ~CLK_tb;
> ```

步驟 17
> 編寫完後,就可以開始跑行為模式模擬測試.
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/21.png "21")

步驟 18
> 接下來看一下行為模擬出來的數據,在35ns(圈一)時,A和B輸入會產生變化,可是S輸出不會有變化,那是因為設計的加法器是由CLK正緣時,才會有觸發開始運算,所以要等到下次的CLK正緣觸發,那就是在50ns(圈2)時,運算才會開始,所以在50ns才會看到算結果,不過這邊要特別強調一下在真實電路中,不會像上面看到的觸發時,立刻產生變化,會有運算時間和電路延遲時間等等.
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/22.png "22")

步驟 19
> 都測試完成後,且沒有功能上的錯誤,就可以開始把測試完的電路包裝成IP.
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/23.png "23")

步驟 20
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/24.png "24")

步驟 21
> 因為PS和PL需要做通訊,而這次也是用AXI-GPIO,所以選擇這個要來建立.
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/25.png "25")

步驟 22
> 會建立一個IP集路徑,而可以把其他自己做的IP都放進去這IP集路徑,要是下次要用,就可以直接把所有自己做的IP都加進去.
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/26.png "26")

步驟 23
> 這邊會做設定AXI-GPIO,像是增加AXI-GPIO數量和要有多少個記憶體等等,都可以依需要自行更改.
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/27.png "27")

步驟 24
> 去編輯IP.
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/28.png "28")

步驟 25
> 會自動開啟一個新建的Vivado,就用這新建的Vivado編輯自己的IP.
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/29.png "29")

步驟 26
> 現在要把剛剛測試完的功能加進IP中.
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/30.png "30")

步驟 27
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/31.png "31")

步驟 28
> 把我們剛剛做的加進去.
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/32.png "32")
> 剛剛做的功能的檔案路徑如下：
> ```
> "專案名稱"/"專案名稱" + .srcs/sources_1/new/"檔案" + .v
> ```
> 例.
> ```
> MyIP_Test/MyIP_Test.srcs/sources_1/new/MyIP_Adder8bit.v
> ```

步驟 29
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/33.png "33")

步驟 30
> 把測試完的功能加進去IP中.
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/34.png "34")
> 在最下面加入這些程式碼,讓功能加進IP中.<br>
> S_AXI_ACLK--->這是AXI在用的CLK,直接拉進來共用.<br>
> slv_reg0--->這是編號零的記憶體,把它做為PS和PL交換數據用.<br>
> MyIP_out--->這是自行宣告的,用作輸出用.
> ```sv
> wire [8:0] MyIP_out;
> MyIP_Adder8bit U1(.CLK(S_AXI_ACLK), .A(slv_reg0[7:0]), .B(slv_reg0[15:8]), .S(MyIP_out));
> ```
> 修改這行,是為了要把自己IP運算完的數據,從PL送回PS.
> ```sv
> 2'h1   : reg_data_out <= MyIP_out;
> ```

步驟 31
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/35.png "35")

步驟 32
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/36.png "36")

步驟 33
> 在這邊自己的IP就完成了.
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/37.png "37")

# 專案製作-Vivado設計部份
步驟 1
> 再創建一個新的專案,要當實做用的專案.<br>
> 假如不會創建的話可以到我之前做的範例Vivado部份的步驟1到步驟6中看到,傳送門如下：
> https://github.com/ANAN030/Vivado_Basic
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/38.png "38")

步驟 2
> 創建設計區塊.
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/39.png "39")

步驟 3
> 加入PS的部份.
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/40.png "40")

步驟 4
> 讓Vivado自動接線.
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/41.png "41")

步驟 5
> 加入AXI_GPIO.
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/42.png "42")

步驟 6
> GPIO設定為LED.
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/43.png "43")

步驟 7
> AXI-GPIO接線設定.
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/44.png "44")

步驟 8
> 現在直接去找我們自建的IP,會是沒有的,所以我們要先將自建的IP加進來.
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/45.png "45")

步驟 9
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/46.png "46")

步驟 10
> 把IP集加進去(IP集路徑在建立自己的IP中的步驟22)
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/47.png "47")

步驟 11
> 這邊就可以看到剛剛做的IP了.
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/48.png "48")

步驟 12
> 輸入自建的IP,就可以看到了.
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/49.png "49")

步驟 13
> AXI-GPIO接線設定.
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/50.png "50")

步驟 14
> 儲存與驗證.
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/52.png "52")
> 假如你有出現這個警告,通常是你用Vivado 2017的版本會出現的問題,而這不會影響到結果,所以這邊先無視.<br>
> 我有找到也有人遇到這問題的解釋,假如有興趣可以點進去看看,傳送門如下：<br>
> https://forums.xilinx.com/t5/Design-Entry/Vivado-critical-warning-when-creating-hardware-wrapper/m-p/767113#M13539
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/51.png "51")

步驟 15
> 將設計區塊的設計,自動生成為HDL（硬體描述語言）和相對應的約束文件.
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/53.png "53")

步驟 16
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/54.png "54")

步驟 17
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/55.png "55")

步驟 18
> 將剛剛生成的HDL,用頂層文件包裝起來.
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/56.png "56")

步驟 19
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/57.png "57")

步驟 20
> 接下來就是生成位元流,而FPGA就是靠這位元流來設定電路的.
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/58.png "58")

步驟 21
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/59.png "59")

步驟 22
> 可以調高使用多少核心去做生成,可以稍微加速一點.
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/60.png "60")

步驟 23
> 等一小段時間,讓Vivado生成.
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/61.png "61")

步驟 24
> 生成完後,這邊我們就不去看生成後的電路分佈了,有興趣可以按OK進去看一下.
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/62.png "62")

步驟 25
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/63.png "63")

步驟 26
> "Include bitstream"這要勾起,不然等等要自己去選擇位元流檔的位置,除非你要用另外的位元流檔.
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/64.png "64")

步驟 27
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/65.png "65")

步驟 28
> 這是Vivado的最後步驟,Vivado會去打開Xilinx SDK,那我們就可開始設計PS部份了.
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/66.png "66")

# 專案製作-Xilinx SDK設計部份

步驟 1
> Xilinx SDK一開始會載入一些在Vivado的檔案,等載入完就會看到這個畫面.<br>
> p.s.遇到載入失敗的話,我是把Vivado和SDK分開灌就解決,假如有遇到可以試試看這方法.
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/67.png "67")

步驟 2
> 新增一個專案.
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/68.png "68")

步驟 3
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/69.png "69")

步驟 4
> 選擇"Empty Application",這是建立一個空的專案,你也可以選擇"Hello World",會自動幫你建一些簡單的檔案.
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/70.png "70")

步驟 5
> 因為我選擇空的專案,所以要新增一個.c檔.
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/71.png "71")

步驟 6
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/72.png "72")

步驟 7
> 編寫PS端的C程式.
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/73.png "73")
> 程式碼如下：
> ```C
> #include <stdio.h>
> #include <stdlib.h>
> #include "xparameters.h"    // 參數集.
> #include "xgpio.h"    // 簡化PS對PL的GPIO操作的函數庫.
>
> // 主程式.
> int main()
> {
>     XGpio LED_XGpio;    // 宣告一個GPIO用的結構.
>     u32 adder_out;    // 暫存MyIP_Adder8bit運算結果用.
>
>     XGpio_Initialize(&LED_XGpio, XPAR_AXI_GPIO_0_DEVICE_ID);    // 初始化LED_XGpio.
>     XGpio_SetDataDirection(&LED_XGpio, 1, 0);    // 設置通道.
>
>     printf("Start!!!\n");
>
>     Xil_Out32(XPAR_MYIP_ADDER8BIT_0_S00_AXI_BASEADDR, 0x00000703);    // "0x00000703"寫進MyIP的記憶體位址.
>
>     adder_out = Xil_In32(XPAR_MYIP_ADDER8BIT_0_S00_AXI_BASEADDR + 4);    // 把運算完的結果讀取出來.
>
>     XGpio_DiscreteWrite(&LED_XGpio, 1, adder_out);    // LED_XGpio通道,送adder_out值進去.
>
>     printf("adder_out = %x\n", adder_out);
>
>     return 0;
> }
> ```
> 這是要把計算的數據寫進記憶體中的某個位址,而自建的IP會去讀取記憶體某個位址的數據來做運算,這樣就能達到PS和PL通訊的功能,而那段位址就是"XPAR_MYIP_ADDER8BIT_0_S00_AXI_BASEADDR".
> ```C
> Xil_Out32(XPAR_MYIP_ADDER8BIT_0_S00_AXI_BASEADDR, 0x00000703);    // "0x00000703"寫進MyIP的記憶體位址.
> ```
> 而位址可以到這"xparameters.h"函數庫中看到,那因為在編寫IP功能時(建立自己的IP的步驟30),把記憶體編號零當作輸入運算,所以把要運算的數據寫進"0x43C00000"也就是"XPAR_MYIP_ADDER8BIT_0_S00_AXI_BASEADDR"這參數直接帶入就可以了.
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/73-1.png "73-1")
> 這行的原理就跟剛剛的差不多,由自建的IP去對記憶體做寫入,再由PS端去對記憶體做讀取,就是下面這行的功能,只是地址的讀取就要跟自建的IP所寫入的位址要一致,才會讀到正確的數據.
> ```C
> adder_out = Xil_In32(XPAR_MYIP_ADDER8BIT_0_S00_AXI_BASEADDR + 4);    // 把運算完的結果讀取出來.
> ```
> 那記憶體的位址在自建IP時(建立自己的IP的步驟30),把記憶體編號一改成連接輸出,所以這邊才要把位址指定到對的位址上,因此才要做"XPAR_MYIP_ADDER8BIT_0_S00_AXI_BASEADDR + 4"這個動作.
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/73-2.png "73-2")

步驟 8
> 把燒路線和電源打開.
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/ZedBoard02.png "ZedBoard02")

步驟 9
> 接下來要將Vivado所生成的位元流設定進FPGA晶片中.<br>
> 要是Bitstream沒有東西的話,可以到之前的範例Xilinx SDK部份的步驟10看如何加進去,傳送門如下：<br>
> https://github.com/ANAN030/Vivado_Basic
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/74.png "74")
> 當執行成功後,可以看到藍色的燈會亮起來.
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/ZedBoard04.JPG "ZedBoard04")

步驟 10
> 把UART給接上.
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/ZedBoard03.png "ZedBoard03")

步驟 11
> 選擇端口.
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/75.png "75")

步驟 12
> 那接下來就是在開發板執行.
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/76.png "76")

# 結果
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/77.png "77")
