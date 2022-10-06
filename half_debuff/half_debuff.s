.3ds
.open "code.bin","out.bin",0x100000
.include "ident.s"

.org _SYM_.unit__Enhance__TurnBegin
.region 120,-1
	stmdb	sp!,{r4,lr}
	ldrh	r2,[r0,#2]
	and	r2,r2,#0x7f
	strh	r2,[r0,#2]

	ldrb	r2,[r0,#4]
	bic	r2,r2,#3
	strb	r2,[r0,#4]

	add	r0,r0,#0xf
	mov	r2,#7
@@loop:
	ldsb	r3,[r0,r2]
	asr	r3,r3,#1
	subs	r3,r3,r1
	movlt	r3,#0
	strb	r3,[r0,r2]

	subs	r2,r2,#1
	bge	@@loop

	ldmia	sp!,{r4,pc}
.endregion
.close
