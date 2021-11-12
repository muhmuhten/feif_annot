.3ds
.open "code.bin","out.bin",0x100000
.include "ident.s"

.org _SYM_.castle__CastleUserData__AddFoodNum
	stmdb	sp!,{r4-r5,lr}
	ldr	r3,[r0,#0xd8]
	ldrh	r4,[r0,#0xde]
	cmp	r4,#0
	ldreqd	r4,[pc,@@pattern-.-8]
	streqh	r4,[r0,#0xde]
	streq	r5,[r3,#0]
	streq	r5,[r3,#4]
	streqh	r5,[r3,#8]
	ldrb	r0,[r3,r1]
	adds	r0,r0,r2
	movlt	r0,#0
	cmp	r0,#99
	movgt	r0,#99
	strb	r0,[r3,r1]
	ldmia	sp!,{r4-r5,pc}
@@pattern:
	.word	0x3ff
	.word	0x03030303

.org _SYM_.castle__CastleUserData__AddGemstoneNum
	stmdb	sp!,{r4-r5,lr}
	ldr	r3,[r0,#0xd4]
	ldrh	r4,[r0,#0xdc]
	cmp	r4,#0
	ldreqd	r4,[pc,@@pattern-.-8]
	streqh	r4,[r0,#0xdc]
	streq	r5,[r3,#0]
	streq	r5,[r3,#4]
	streq	r5,[r3,#8]
	ldrb	r0,[r3,r1]
	adds	r0,r0,r2
	movlt	r0,#0
	cmp	r0,#99
	movgt	r0,#99
	strb	r0,[r3,r1]
	ldmia	sp!,{r4-r5,pc}
@@pattern:
	.word	0xfff
	.word	0x03030303

.close
