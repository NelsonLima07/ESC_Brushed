/* Lib J3_DShot_ESC */
/* By: Nelson Lima - jnelsonlima3@gmail.com */
#include "J3_DShot_ESC.h"

/* Definir os pinos ESC B8  */
sbit ESC at GPIOB_ODR.B8;

void SetUm(void)  /* 1250ns em 1 e 420ns em 0 */
{
  unsigned int i;
  ESC = 1;
  for(i=0;i<=10;i++){
    asm {  NOP };
  }
  ESC = 0;
  for(i=0;i<=2;i++){
    asm {  NOP };
  }
}

void SetZero(void) /* 625ns em 1 e 1045ns em 0 */
{
  unsigned int i;
  ESC = 1;
  for(i=0;i<=5;i++){
    asm {  NOP };
  }
  ESC = 0;
  for(i=0;i<=7;i++){
    asm {  NOP };
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
  dado = _val << 1; /* Add Bit 0 for request telemetria */
  //dados = dados | 0x10;    /* 0x10 -> 0b10000 */
  dado = AppendChecksumCRC(dado);
  //DisableInterrupts();
  for(i=16;i>0;i--){
    if((dado >> (i-1)) & 1) {
      SetUm();
    }else{
      SetZero();
    }
  }
  //EnableInterrupts();
}