_SetUm:
;J3_DShot_ESC.c,11 :: 		void SetUm(void)  /* 1250ns em 1 e 420ns em 0 */
;J3_DShot_ESC.c,14 :: 		ESC1 = 1;
MOVS	R1, #1
SXTB	R1, R1
MOVW	R0, #lo_addr(GPIOB_ODR+0)
MOVT	R0, #hi_addr(GPIOB_ODR+0)
_SX	[R0, ByteOffset(GPIOB_ODR+0)]
;J3_DShot_ESC.c,15 :: 		for(i=0;i<=10;i++){
; i start address is: 4 (R1)
MOVS	R1, #0
; i end address is: 4 (R1)
L_SetUm0:
; i start address is: 4 (R1)
CMP	R1, #10
IT	HI
BHI	L_SetUm1
;J3_DShot_ESC.c,16 :: 		asm {  NOP };
NOP
;J3_DShot_ESC.c,15 :: 		for(i=0;i<=10;i++){
ADDS	R1, R1, #1
UXTH	R1, R1
;J3_DShot_ESC.c,17 :: 		}
; i end address is: 4 (R1)
IT	AL
BAL	L_SetUm0
L_SetUm1:
;J3_DShot_ESC.c,18 :: 		ESC1 = 0;
MOVS	R1, #0
SXTB	R1, R1
MOVW	R0, #lo_addr(GPIOB_ODR+0)
MOVT	R0, #hi_addr(GPIOB_ODR+0)
_SX	[R0, ByteOffset(GPIOB_ODR+0)]
;J3_DShot_ESC.c,19 :: 		for(i=0;i<=2;i++){
; i start address is: 4 (R1)
MOVS	R1, #0
; i end address is: 4 (R1)
L_SetUm3:
; i start address is: 4 (R1)
CMP	R1, #2
IT	HI
BHI	L_SetUm4
;J3_DShot_ESC.c,20 :: 		asm {  NOP };
NOP
;J3_DShot_ESC.c,19 :: 		for(i=0;i<=2;i++){
ADDS	R1, R1, #1
UXTH	R1, R1
;J3_DShot_ESC.c,21 :: 		}
; i end address is: 4 (R1)
IT	AL
BAL	L_SetUm3
L_SetUm4:
;J3_DShot_ESC.c,22 :: 		}
L_end_SetUm:
BX	LR
; end of _SetUm
_SetZero:
;J3_DShot_ESC.c,24 :: 		void SetZero(void) /* 625ns em 1 e 1045ns em 0 */
;J3_DShot_ESC.c,27 :: 		ESC1 = 1;
MOVS	R1, #1
SXTB	R1, R1
MOVW	R0, #lo_addr(GPIOB_ODR+0)
MOVT	R0, #hi_addr(GPIOB_ODR+0)
_SX	[R0, ByteOffset(GPIOB_ODR+0)]
;J3_DShot_ESC.c,28 :: 		for(i=0;i<=5;i++){
; i start address is: 4 (R1)
MOVS	R1, #0
; i end address is: 4 (R1)
L_SetZero6:
; i start address is: 4 (R1)
CMP	R1, #5
IT	HI
BHI	L_SetZero7
;J3_DShot_ESC.c,29 :: 		asm {  NOP };
NOP
;J3_DShot_ESC.c,28 :: 		for(i=0;i<=5;i++){
ADDS	R1, R1, #1
UXTH	R1, R1
;J3_DShot_ESC.c,30 :: 		}
; i end address is: 4 (R1)
IT	AL
BAL	L_SetZero6
L_SetZero7:
;J3_DShot_ESC.c,31 :: 		ESC1 = 0;
MOVS	R1, #0
SXTB	R1, R1
MOVW	R0, #lo_addr(GPIOB_ODR+0)
MOVT	R0, #hi_addr(GPIOB_ODR+0)
_SX	[R0, ByteOffset(GPIOB_ODR+0)]
;J3_DShot_ESC.c,32 :: 		for(i=0;i<=7;i++){
; i start address is: 4 (R1)
MOVS	R1, #0
; i end address is: 4 (R1)
L_SetZero9:
; i start address is: 4 (R1)
CMP	R1, #7
IT	HI
BHI	L_SetZero10
;J3_DShot_ESC.c,33 :: 		asm {  NOP };
NOP
;J3_DShot_ESC.c,32 :: 		for(i=0;i<=7;i++){
ADDS	R1, R1, #1
UXTH	R1, R1
;J3_DShot_ESC.c,34 :: 		}
; i end address is: 4 (R1)
IT	AL
BAL	L_SetZero9
L_SetZero10:
;J3_DShot_ESC.c,35 :: 		}
L_end_SetZero:
BX	LR
; end of _SetZero
_AppendChecksumCRC:
;J3_DShot_ESC.c,37 :: 		unsigned int AppendChecksumCRC(unsigned int _val)
; _val start address is: 0 (R0)
; _val end address is: 0 (R0)
; _val start address is: 0 (R0)
;J3_DShot_ESC.c,39 :: 		unsigned int csum = 0;
;J3_DShot_ESC.c,41 :: 		csum = (csum_data ^ (csum_data >> 4) ^ (csum_data >> 8)) & 0xf;
LSRS	R1, R0, #4
UXTH	R1, R1
EOR	R2, R0, R1, LSL #0
UXTH	R2, R2
LSRS	R1, R0, #8
UXTH	R1, R1
EOR	R1, R2, R1, LSL #0
UXTH	R1, R1
AND	R2, R1, #15
UXTH	R2, R2
;J3_DShot_ESC.c,42 :: 		return (_val << 4) | csum;
LSLS	R1, R0, #4
UXTH	R1, R1
; _val end address is: 0 (R0)
ORRS	R1, R2
UXTH	R0, R1
;J3_DShot_ESC.c,43 :: 		}
L_end_AppendChecksumCRC:
BX	LR
; end of _AppendChecksumCRC
_J3_DShotESC_setValue:
;J3_DShot_ESC.c,45 :: 		void J3_DShotESC_setValue(unsigned int _val)
; _val start address is: 0 (R0)
SUB	SP, SP, #4
STR	LR, [SP, #0]
; _val end address is: 0 (R0)
; _val start address is: 0 (R0)
;J3_DShot_ESC.c,49 :: 		dado = _val << 1; /* Add Bit 0 for request telemetria */
LSLS	R1, R0, #1
; _val end address is: 0 (R0)
;J3_DShot_ESC.c,51 :: 		dado = AppendChecksumCRC(dado);
UXTH	R0, R1
BL	_AppendChecksumCRC+0
; dado start address is: 8 (R2)
UXTH	R2, R0
;J3_DShot_ESC.c,52 :: 		for(i=16;i>0;i--){
; i start address is: 12 (R3)
MOVS	R3, #16
; i end address is: 12 (R3)
L_J3_DShotESC_setValue12:
; i start address is: 12 (R3)
; dado start address is: 8 (R2)
; dado end address is: 8 (R2)
CMP	R3, #0
IT	LS
BLS	L_J3_DShotESC_setValue13
; dado end address is: 8 (R2)
;J3_DShot_ESC.c,53 :: 		if((dado >> (i-1)) & 1) {
; dado start address is: 8 (R2)
SUBS	R1, R3, #1
SXTH	R1, R1
LSR	R1, R2, R1
UXTH	R1, R1
AND	R1, R1, #1
UXTH	R1, R1
CMP	R1, #0
IT	EQ
BEQ	L_J3_DShotESC_setValue15
;J3_DShot_ESC.c,54 :: 		SetUm();
BL	_SetUm+0
;J3_DShot_ESC.c,55 :: 		}else{
IT	AL
BAL	L_J3_DShotESC_setValue16
L_J3_DShotESC_setValue15:
;J3_DShot_ESC.c,56 :: 		SetZero();
BL	_SetZero+0
;J3_DShot_ESC.c,57 :: 		}
L_J3_DShotESC_setValue16:
;J3_DShot_ESC.c,52 :: 		for(i=16;i>0;i--){
SUBS	R3, R3, #1
UXTB	R3, R3
;J3_DShot_ESC.c,58 :: 		}
; dado end address is: 8 (R2)
; i end address is: 12 (R3)
IT	AL
BAL	L_J3_DShotESC_setValue12
L_J3_DShotESC_setValue13:
;J3_DShot_ESC.c,59 :: 		}
L_end_J3_DShotESC_setValue:
LDR	LR, [SP, #0]
ADD	SP, SP, #4
BX	LR
; end of _J3_DShotESC_setValue
_J3_DShotESC_Init:
;J3_DShot_ESC.c,61 :: 		void J3_DShotESC_Init(){
SUB	SP, SP, #4
STR	LR, [SP, #0]
;J3_DShot_ESC.c,64 :: 		for(i=0;i<1000;i++){
; i start address is: 16 (R4)
MOVS	R4, #0
SXTH	R4, R4
; i end address is: 16 (R4)
L_J3_DShotESC_Init17:
; i start address is: 16 (R4)
CMP	R4, #1000
IT	GE
BGE	L_J3_DShotESC_Init18
;J3_DShot_ESC.c,65 :: 		J3_DShotESC_setValue(0);
MOVS	R0, #0
BL	_J3_DShotESC_setValue+0
;J3_DShot_ESC.c,66 :: 		Delay_us(1500);
MOVW	R7, #19999
MOVT	R7, #0
NOP
NOP
L_J3_DShotESC_Init20:
SUBS	R7, R7, #1
BNE	L_J3_DShotESC_Init20
NOP
NOP
NOP
;J3_DShot_ESC.c,64 :: 		for(i=0;i<1000;i++){
ADDS	R4, R4, #1
SXTH	R4, R4
;J3_DShot_ESC.c,67 :: 		}  // 1500us = 1,5ms * 1000 =  1,5s
; i end address is: 16 (R4)
IT	AL
BAL	L_J3_DShotESC_Init17
L_J3_DShotESC_Init18:
;J3_DShot_ESC.c,69 :: 		for(i=0;i<1000;i++){
; i start address is: 16 (R4)
MOVS	R4, #0
SXTH	R4, R4
; i end address is: 16 (R4)
L_J3_DShotESC_Init22:
; i start address is: 16 (R4)
CMP	R4, #1000
IT	GE
BGE	L_J3_DShotESC_Init23
;J3_DShot_ESC.c,70 :: 		J3_DShotESC_setValue(48);
MOVS	R0, #48
BL	_J3_DShotESC_setValue+0
;J3_DShot_ESC.c,71 :: 		Delay_us(1500);
MOVW	R7, #19999
MOVT	R7, #0
NOP
NOP
L_J3_DShotESC_Init25:
SUBS	R7, R7, #1
BNE	L_J3_DShotESC_Init25
NOP
NOP
NOP
;J3_DShot_ESC.c,69 :: 		for(i=0;i<1000;i++){
ADDS	R4, R4, #1
SXTH	R4, R4
;J3_DShot_ESC.c,72 :: 		}  // 1500us = 1,5ms * 1000 =  1,5s
; i end address is: 16 (R4)
IT	AL
BAL	L_J3_DShotESC_Init22
L_J3_DShotESC_Init23:
;J3_DShot_ESC.c,74 :: 		for(i=0;i<1000;i++){
; i start address is: 16 (R4)
MOVS	R4, #0
SXTH	R4, R4
; i end address is: 16 (R4)
L_J3_DShotESC_Init27:
; i start address is: 16 (R4)
CMP	R4, #1000
IT	GE
BGE	L_J3_DShotESC_Init28
;J3_DShot_ESC.c,75 :: 		J3_DShotESC_setValue(0);
MOVS	R0, #0
BL	_J3_DShotESC_setValue+0
;J3_DShot_ESC.c,76 :: 		Delay_us(1500);
MOVW	R7, #19999
MOVT	R7, #0
NOP
NOP
L_J3_DShotESC_Init30:
SUBS	R7, R7, #1
BNE	L_J3_DShotESC_Init30
NOP
NOP
NOP
;J3_DShot_ESC.c,74 :: 		for(i=0;i<1000;i++){
ADDS	R4, R4, #1
SXTH	R4, R4
;J3_DShot_ESC.c,77 :: 		}  // 1500us = 1,5ms * 1000 =  1,5s
; i end address is: 16 (R4)
IT	AL
BAL	L_J3_DShotESC_Init27
L_J3_DShotESC_Init28:
;J3_DShot_ESC.c,78 :: 		}
L_end_J3_DShotESC_Init:
LDR	LR, [SP, #0]
ADD	SP, SP, #4
BX	LR
; end of _J3_DShotESC_Init
