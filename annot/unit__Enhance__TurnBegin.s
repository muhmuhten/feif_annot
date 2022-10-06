.3ds
.open "code.bin","out.bin",0x100000
.include "ident.s"

.org _SYM_.unit__Enhance__TurnBegin
	str	r4,[sp,#-4]!
	ldrb	r2,[r0,#4]
	cmp	r1,#0
	movne	r4,#2
	bic	r2,r2,#2
	strb	r2,[r0,#4]

	ldrb	r2,[r0,#2]
	moveq	r4,#1
	bic	r2,r2,#0x80
	strb	r2,[r0,#2]

	ldrb	r2,[r0,#3]
	bic	r2,r2,#0xff
	strb	r2,[r0,#3]

	ldrb	r2,[r0,#4]
	bic	r2,r2,#1
	strb	r2,[r0,#4]

	mov	r2,#1
@@loop:
	add	r1,r0,r2
	mov	r3,r2
	ldrsb	r1,[r1,#0xf]
	add	r12,r0,#0xf
	add	r2,r2,#1
	sub	r1,r1,r4
	cmp	r1,#0
	movlt	r1,#0
	cmp	r2,#8
	strb	r1,[r12,r3]
	blt	@@loop

	ldr	r4,[sp],#4
	bx	lr
.close
