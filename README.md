# Vivado_NewMyIP
這次會用Vivado做一個自己的IP,並跑模擬測試IP功能是否正確,而IP功能會做一個簡單的8-bit加法器,
最後並搭配AXI-GPIO和LED一起實做.

# 影片
未完成......

# 建立自己的IP
步驟 1
> 創建一個新的專案,要做為測試自己IP用功能用.<br>
> 假如不會創建的話可以到我之前做的範例步驟1到步驟6中看到,傳送門如下：<br>
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
> <br>因為要做8-bit的加法器,所以輸入的A和B會設定成8-bit,不過要注意輸出的部份,那就是S會設定為9-bit,那是因為會有溢位,下面我簡單舉個例子,讓各位更清楚.<br>
> ```
> 例.
>
>      1101 0001   ---> 209
>  +   0110 0100   ---> 100
> ————————————————
>    1 0011 0101   ---> 9-bit的話值會是309,要是8-bit的話值就變成53
> ```
> 參數設定如下：
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/07.png "07")

步驟 8
> 開始設計自己的IP功能,這邊我就不用邏輯閘的方式去設計加法器了,就直接使用Vivado內建的加法器,假如你需要其它功能,再自己設計就好.
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
> 一開始不會有reg,要自行加上.
> ```sv
> output reg [8:0] S
> ```
> "posedge CLK"代表CLK正緣觸發,觸發時,執行區塊內的動作.
> ```sv
> always @ (posedge CLK) begin
>     .
>     .
>     .
> end
> ```
> 這邊的"+"在合成時,會由合成工具生成加法的電路.
> ```sv
> S = A + B;
> ```


步驟 9
> 設計完IP功能後,接下來就是要建立模擬測試用的檔案.
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
> 要先把所有的做初始化的動作,不然模擬時,一開始都會是亂碼(X),再來"#35"功能是等待35個時間單位,才會開始執行下一個程式.
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
> 專案路徑會建立一個資料夾,而這資料夾可以把其他自己做的IP都放進去,要是下次要用,就可以直接把所有自己做的IP都加進去.
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/26.png "26")

步驟 23
> 這邊會做設定AXI-GPIO,像是增加AXI-GPIO和要有多少個記體體等等,都依需要可以自行更改.
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/27.png "27")

步驟 24
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/28.png "28")

步驟 25
> 會自動開啟一個新的Vivado,就用這新開的開始建立自己的IP.
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/29.png "29")

步驟 26
> 現在要把剛剛測試完的功能加進IP中.
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/30.png "30")

步驟 27
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/31.png "31")

步驟 28
> 把我們剛剛做的加進去.
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/32.png "32")
> 檔案路徑：
> ```
> "專案名稱"/"專案名稱" + .srcs/sources_1/new
> ```
> 例.
> ```
> MyIP_Test/MyIP_Test.srcs/sources_1/new
> ```

步驟 29
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/33.png "33")

步驟 30
> 把測試完的功能加進去IP中.
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/34.png "34")
> 在最下面加入這些程式碼,讓功能加進IP中.<br>
> S_AXI_ACLK--->這是AXI的CLK,直接拉進來共用.<br>
> slv_reg0--->這是編號零的記憶體,我們把它做為PS對PL送數據用.<br>
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
> 再創建一個新的專案,要當實做用的專案.
> 假如不會創建的話可以到我之前做的範例步驟1到步驟6中看到,傳送門如下：
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
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/44.png "44")

步驟 8
> 現在直接去找我們自建的IP,會是沒有的,所以我們要先將自建的IP加進來.
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/45.png "45")

步驟 9
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/46.png "46")

步驟 10
> 把自建的IP加進去(路徑在建立自己的IP中的步驟22)
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/47.png "47")
