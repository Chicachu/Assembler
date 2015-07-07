		.ORIG x3000
		AND R0 R0 #0
		GCD		LD R2 SavedR2
LABEL	AND R1 R1 #0
		ADD R0 R0 R6
		ADD R0 R0 #15
		BRn x43
		BRz #242
		BRp x202
		LD R2 OTHERLABEL
		LD R3 #52
		RET 
		TRAP x25
		NOT R4 R2 R5
		JSR GCD 

		HALT
OTHERLABEL

; GCD
; input param R0, R1  (x, y)
; return value in R4
GCD		LD R2 SavedR2

		NOT R2 R1
		ADD R2 R2 #1   ; R2 is now the two's complement of R1  (-y)
		ADD R3 R2 R0   ; R3 <- (x - y)
		BRn xLesser    ; if (x < y)
		
		AND R4 R4 #0
		ADD R4 R4 R1   ; lesser = y

		; clear R2 and R3 for later use
		AND R2 R2 #0
		AND R3 R3 #0
		ST R2 SavedR2

		BR StartWhile     
xLesser		ADD R4 R4 R0   ; lesser = x
StartWhile	AND R3 R3 #0
		ADD R3 R3 R0   ; move x to R3
		JSR MOD
		AND R2 R2 #0
		ADD R2 R2 R3   ; move return value from MOD call to R2
		AND R3 R3 #0   
		ADD R3 R3 R1   ; move y to R3
		JSR MOD
		AND R5 R5 #0   
		ADD R5 R5 R3   ; move return value from MOD call to R5

		; if (R2 == 0 AND R5 == 0) return R4 (lesser)	
		AND R3 R3 #0
		ADD R3 R2 R5
		BRz Return        ; if R2 + R5 = 0, return
		
		ADD R4 R4 #-1
		BR StartWhile

Return		LD R2 SavedR2
		LD R3 SavedR3
		LD R4 SavedR4
		LD R5 SavedR5
		LD R7 SavedR7
		RET

SavedR2		.BLKW 1
SavedR3		.BLKW 1
SavedR4		.BLKW 1
SavedR5		.BLKW 1
SavedR7		.BLKW 1

; MOD 
; input param R3, R4
; return output in R3
MOD		ST R1 SavedR1
		ST R7 SavedR72
		
		NOT R1 R4
		ADD R1 R1 #1  ; R1 now Two's Complement of R4
BeginLoop	ADD R3 R3 R1  ; continue subtracting R1 from R3 until R3 is negative  
		BRp BeginLoop
		
		BRz Zero      ; if 0, don't add back R4
		ADD R3 R3 R4
	
Zero		LD R1 SavedR1
		LD R7 SavedR72
		RET	

SavedR1		.BLKW 1
SavedR72		.BLKW 1
		.END
	