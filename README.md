# Vivado_NewMyIP
這次會用Vivado做一個自己的IP,並跑模擬測試IP功能是否正確,而IP功能會做一個簡單的8-bit加法器,
最後並搭配AXI-GPIO和LED一起實做.

# 建立自己的IP
步驟 1
> 創建一個新的專案,要做建立自己IP用.<br>
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
> 兩個要計算的A和B,及一個觸發CLK和運算過後的輸出S.
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/07-1.png "07")
> 因為要做8-bit的加法器,所以輸入的A和B會設定成8-bit,不過要注意輸出的部份,那就是S會設定為9-bit,那是因為會有溢位,下面我簡單舉個例子,讓各位更清楚.<br>
> ```
> 例.
>
>      1101 0001   ---> 209
>  +   0110 0100   ---> 100
> ————————————————
>    1 0011 0101   ---> 9-bit的話值會是309,要是8-bit的話值就變成53
> ```
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/07.png "07")

步驟 8
> 開始設計自己的IP功能,這邊我就不用邏輯閘的方式去設計加法器了,就直接使用Vivado內建的加法器,假如你需要特殊的加法器或其它功能,在自己設計就好.
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/08.png "08")
> 程式碼如下：
> ```v
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

步驟 9
> 設計完IP功能後,接下來就是要建立模擬測試用的檔案.
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
> 這邊就可以開始編寫,模擬測試用的程式.
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/20.png "20")
> 程式碼如下：
> ```v
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

步驟 17
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/21.png "21")

步驟 18
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/22.png "22")

步驟 19
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/23.png "23")

步驟 20
> ![GITHUB](https://raw.githubusercontent.com/ANAN030/Vivado_NewMyIP/master/image/24.png "24")
