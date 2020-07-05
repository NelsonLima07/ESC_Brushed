_SetUm:
;J3_DShot_ESC.c,8 :: 		void SetUm(void)  /* 1250ns em 1 e 420ns em 0 */
;J3_DShot_ESC.c,11 :: 		ESC = 1;
MOVS	R1, #1
SXTB	R1, R1
MOVW	R0, #lo_addr(GPIOB_ODR+0)
MOVT	R0, #hi_addr(GPIOB_ODR+0)
_SX	[R0, ByteOffset(GPIOB_ODR+0)]
;J3_DShot_ESC.c,12 :: 		for(i=0;i<=10;i++){
; i start address is: 4 (R1)
MOVS	R1, #0
; i end address is: 4 (R1)
L_SetUm0:
; i start address is: 4 (R1)
CMP	R1, #10
IT	HI
BHI	L_SetUm1
;J3_DShot_ESC.c,13 :: 		asm {  NOP };
NOP
;J3_DShot_ESC.c,12 :: 		for(i=0;i<=10;i++){
ADDS	R1, R1, #1
UXTH	R1, R1
;J3_DShot_ESC.c,14 :: 		}
; i end address is: 4 (R1)
IT	AL
BAL	L_SetUm0
L_SetUm1:
;J3_DShot_ESC.c,15 :: 		ESC = 0;
MOVS	R1, #0
SXTB	R1, R1
MOVW	R0, #lo_addr(GPIOB_ODR+0)
MOVT	R0, #hi_addr(GPIOB_ODR+0)
_SX	[R0, ByteOffset(GPIOB_ODR+0)]
;J3_DShot_ESC.c,16 :: 		for(i=0;i<=2;i++){
; i start address is: 4 (R1)
MOVS	R1, #0
; i end address is: 4 (R1)
L_SetUm3:
; i start address is: 4 (R1)
CMP	R1, #2
IT	HI
BHI	L_SetUm4
;J3_DShot_ESC.c,17 :: 		asm {  NOP };
NOP
;J3_DShot_ESC.c,16 :: 		for(i=0;i<=2;i++){
ADDS	R1, R1, #1
UXTH	R1, R1
;J3_DShot_ESC.c,18 :: 		}
; i end address is: 4 (R1)
IT	AL
BAL	L_SetUm3
L_SetUm4:
;J3_DShot_ESC.c,19 :: 		}
L_end_SetUm:
BX	LR
; end of _SetUm
_SetZero:
;J3_DShot_ESC.c,21 :: 		void SetZero(void) /* 625ns em 1 e 1045ns em 0 */
;J3_DShot_ESC.c,24 :: 		ESC = 1;
MOVS	R1, #1
SXTB	R1, R1
MOVW	R0, #lo_addr(GPIOB_ODR+0)
MOVT	R0, #hi_addr(GPIOB_ODR+0)
_SX	[R0, ByteOffset(GPIOB_ODR+0)]
;J3_DShot_ESC.c,25 :: 		for(i=0;i<=5;i++){
; i start address is: 4 (R1)
MOVS	R1, #0
; i end address is: 4 (R1)
L_SetZero6:
; i start address is: 4 (R1)
CMP	R1, #5
IT	HI
BHI	L_SetZero7
;J3_DShot_ESC.c,26 :: 		asm {  NOP };
NOP
;J3_DShot_ESC.c,25 :: 		for(i=0;i<=5;i++){
ADDS	R1, R1, #1
UXTH	R1, R1
;J3_DShot_ESC.c,27 :: 		}
; i end address is: 4 (R1)
IT	AL
BAL	L_SetZero6
L_SetZero7:
;J3_DShot_ESC.c,28 :: 		ESC = 0;
MOVS	R1, #0
SXTB	R1, R1
MOVW	R0, #lo_addr(GPIOB_ODR+0)
MOVT	R0, #hi_addr(GPIOB_ODR+0)
_SX	[R0, ByteOffset(GPIOB_ODR+0)]
;J3_DShot_ESC.c,29 :: 		for(i=0;i<=7;i++){
; i start address is: 4 (R1)
MOVS	R1, #0
; i end address is: 4 (R1)
L_SetZero9:
; i start address is: 4 (R1)
CMP	R1, #7
IT	HI
BHI	L_SetZero10
;J3_DShot_ESC.c,30 :: 		asm {  NOP };
NOP
;J3_DShot_ESC.c,29 :: 		for(i=0;i<=7;i++){
ADDS	R1, R1, #1
UXTH	R1, R1
;J3_DShot_ESC.c,31 :: 		}
; i end address is: 4 (R1)
IT	AL
BAL	L_SetZero9
L_SetZero10:
;J3_DShot_ESC.c,32 :: 		}
L_end_SetZero:
BX	LR
; end of _SetZero
_AppendChecksumCRC:
;J3_DShot_ESC.c,34 :: 		unsigned int AppendChecksumCRC(unsigned int _val)
; _val start address is: 0 (R0)
; _val end address is: 0 (R0)
; _val start address is: 0 (R0)
;J3_DShot_ESC.c,36 :: 		unsigned int csum = 0;
;J3_DShot_ESC.c,38 :: 		csum = (csum_data ^ (csum_data >> 4) ^ (csum_data >> 8)) & 0xf;
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
;J3_DShot_ESC.c,39 :: 		return (_val << 4) | csum;
LSLS	R1, R0, #4
UXTH	R1, R1
; _val end address is: 0 (R0)
ORRS	R1, R2
UXTH	R0, R1
;J3_DShot_ESC.c,40 :: 		}
L_end_AppendChecksumCRC:
BX	LR
; end of _AppendChecksumCRC
_DShotESC_setValue:
;J3_DShot_ESC.c,42 :: 		void DShotESC_setValue(unsigned int _val)
; _val start address is: 0 (R0)
SUB	SP, SP, #4
STR	LR, [SP, #0]
; _val end address is: 0 (R0)
; _val start address is: 0 (R0)
;J3_DShot_ESC.c,46 :: 		dado = _val << 1; /* Add Bit 0 for request telemetria */
LSLS	R1, R0, #1
; _val end address is: 0 (R0)
;J3_DShot_ESC.c,48 :: 		dado = AppendChecksumCRC(dado);
UXTH	R0, R1
BL	_AppendChecksumCRC+0
; dado start address is: 8 (R2)
UXTH	R2, R0
;J3_DShot_ESC.c,50 :: 		for(i=16;i>0;i--){
; i start address is: 12 (R3)
MOVS	R3, #16
; i end address is: 12 (R3)
L_DShotESC_setValue12:
; i start address is: 12 (R3)
; dado start address is: 8 (R2)
; dado end address is: 8 (R2)
CMP	R3, #0
IT	LS
BLS	L_DShotESC_setValue13
; dado end address is: 8 (R2)
;J3_DShot_ESC.c,51 :: 		if((dado >> (i-1)) & 1) {
; dado start address is: 8 (R2)
SUBS	R1, R3, #1
SXTH	R1, R1
LSR	R1, R2, R1
UXTH	R1, R1
AND	R1, R1, #1
UXTH	R1, R1
CMP	R1, #0
IT	EQ
BEQ	L_DShotESC_setValue15
;J3_DShot_ESC.c,52 :: 		SetUm();
BL	_SetUm+0
;J3_DShot_ESC.c,53 :: 		}else{
IT	AL
BAL	L_DShotESC_setValue16
L_DShotESC_setValue15:
;J3_DShot_ESC.c,54 :: 		SetZero();
BL	_SetZero+0
;J3_DShot_ESC.c,55 :: 		}
L_DShotESC_setValue16:
;J3_DShot_ESC.c,50 :: 		for(i=16;i>0;i--){
SUBS	R3, R3, #1
UXTB	R3, R3
;J3_DShot_ESC.c,56 :: 		}
; dado end address is: 8 (R2)
; i end address is: 12 (R3)
IT	AL
BAL	L_DShotESC_setValue12
L_DShotESC_setValue13:
;J3_DShot_ESC.c,58 :: 		}
L_end_DShotESC_setValue:
LDR	LR, [SP, #0]
ADD	SP, SP, #4
BX	LR
; end of _DShotESC_setValue
