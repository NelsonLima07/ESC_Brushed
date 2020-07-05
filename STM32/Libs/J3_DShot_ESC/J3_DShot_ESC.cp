#line 1 "C:/NelsonLima/Projetos/03_ESC_Brushed/ESC_Brushed.git/trunk/STM32/Libs/J3_DSHOT_ESC/J3_DShot_ESC.c"
#line 1 "c:/nelsonlima/projetos/03_esc_brushed/esc_brushed.git/trunk/stm32/libs/j3_dshot_esc/j3_dshot_esc.h"







void DShotESC_setValue(unsigned int _val);
#line 6 "C:/NelsonLima/Projetos/03_ESC_Brushed/ESC_Brushed.git/trunk/STM32/Libs/J3_DSHOT_ESC/J3_DShot_ESC.c"
sbit ESC at GPIOB_ODR.B8;

void SetUm(void)
{
 unsigned int i;
 ESC = 1;
 for(i=0;i<=10;i++){
 asm { NOP };
 }
 ESC = 0;
 for(i=0;i<=2;i++){
 asm { NOP };
 }
}

void SetZero(void)
{
 unsigned int i;
 ESC = 1;
 for(i=0;i<=5;i++){
 asm { NOP };
 }
 ESC = 0;
 for(i=0;i<=7;i++){
 asm { NOP };
 }
}

unsigned int AppendChecksumCRC(unsigned int _val)
{
 unsigned int csum = 0;
 unsigned int csum_data = _val;
 csum = (csum_data ^ (csum_data >> 4) ^ (csum_data >> 8)) & 0xf;
 return (_val << 4) | csum;
}

void DShotESC_setValue(unsigned int _val)
{
 unsigned char i;
 unsigned int dado;
 dado = _val << 1;

 dado = AppendChecksumCRC(dado);

 for(i=16;i>0;i--){
 if((dado >> (i-1)) & 1) {
 SetUm();
 }else{
 SetZero();
 }
 }

}
