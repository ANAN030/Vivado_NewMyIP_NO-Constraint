#include <stdio.h>
#include <stdlib.h>
#include "xparameters.h"    // 參數集.
#include "xgpio.h"    // 簡化PS對PL的GPIO操作的函數庫.

// 主程式.
int main()
{
    XGpio LED_XGpio;    // 宣告一個GPIO用的結構.
    u32 adder_out;    // 暫存MyIP_Adder8bit運算結果用.

    XGpio_Initialize(&LED_XGpio, XPAR_AXI_GPIO_0_DEVICE_ID);    // 初始化LED_XGpio.
    XGpio_SetDataDirection(&LED_XGpio, 1, 0);    // 設置通道.

    printf("Start!!!\n");

    Xil_Out32(XPAR_MYIP_ADDER8BIT_0_S00_AXI_BASEADDR, 0x00000703);    // "0x00000703"寫進MyIP的記憶體位址.

    adder_out = Xil_In32(XPAR_MYIP_ADDER8BIT_0_S00_AXI_BASEADDR + 4);    // 把運算完的結果讀取出來.

    XGpio_DiscreteWrite(&LED_XGpio, 1, adder_out);    // LED_XGpio通道,送adder_out值進去.

    printf("adder_out = %x\n", adder_out);

    return 0;
}
