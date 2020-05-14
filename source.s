.3ds
.open "code.bin","out.bin",0x100000
.include "autosym.s"

.org _SYM_.Unit__LevelUp
.area 0x3d91c0 - 0x3d9054
.area _SYM_.Unit__DoubleOn - .
;; Local callee-saved variables:
;; r4 no longer used
;; r5 = stat cap
;; r6 = which stat
;; r7 = this :: Unit
;; r8 = this + 0xc8 :: start of personal stats array (+ access to high offsets)
;; r9 = eternal seal (level > 20) state
;; r10 = internal level + level + 1 per stat
;; r11 no longer used
Unit__LevelUp:
	stmdb	sp!,{r4-r11,lr}
	sub	sp,sp,#0x3c
	mov	r7,r0
	add	r8,r0,#0xc8
	
	; since all entries leave the level in r1 anyway, we can skip the load
	;ldrb	r1,[r7,#0xf1]
	ldr	r2,[r7,#0x9c]	; Unit+0x9c Person pointer
	ldrb	r3,[r7,#0x130]	; Unit+0x130 eternal seals
	ldrb	r9,[r2,#0x86]	; Person+0x86 eternal seals
	ldrsb	r10,[r8,#0x67]	; Unit+0x12f internal level

	sub	r9,r3,r9
	add	r10,r10,r1
	add	r1,r1,#1
	mov	r3,#0
	mov	r6,#7

	strb	r1,[r7,#0xf1]
	str	r3,[sp,#0]
	str	r3,[sp,#4]

@@stat_loop:
	mov	r3,#0
	mov	r2,#0
	mov	r1,r6
	mov	r0,r7
	bl	_SYM_.Unit__GetCapabilityImpl
	mov	r5,r0

	mov	r1,r6
	mov	r0,r7
	bl	_SYM_.Unit__GetLimit
	sub	r5,r0,r5

	mov	r1,r6
	mov	r0,r7
	bl	_SYM_.Unit__GetGrow

	mov	r1,#41
	mul	r0,r0,r1
	mul	r1,r0,r10
	sub	r10,r10,#1
	mul	r0,r0,r10

	add	r1,r1,asr #20
	add	r0,r0,asr #20
	sub	r1,r1,asr #10
	sub	r0,r0,asr #10

	mov	r1,r1,asr #12
	sub	r1,r1,r0,asr #12

	cmp	r1,r5
	movgt	r1,r5

	ldrb	r0,[r8,r6]
	add	r0,r0,r1
	strb	r0,[r8,r6]

	; Mark eternal seal levels as stat boosters for handicap PvP
	cmp	r9,#0
	beq	@@stat_next

	add	r2,r7,#0xe0
	ldrb	r0,[r2,r6]
	add	r0,r0,r1
	strb	r0,[r2,r6]

@@stat_next:
	subs	r6,r6,#1
	bge	@@stat_loop

	add	sp,sp,#0x3c
	ldmia	sp!,{r4-r11,pc}

.skip 144
.endarea
.endarea
.close
