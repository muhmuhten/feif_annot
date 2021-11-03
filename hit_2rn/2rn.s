.3ds
.open "code.bin","out.bin",0x100000
.include "ident.s"

.org _SYM_.map__battle__detail__RandomCalculateHit
	stmdb	sp!,{r4-r6,lr}
	mov	r4,r0
	ldr	r0,[@@rng_state]
	mov	r1,#100
	bl	_SYM_.Random__GetValue
	mov	r5,r0
	ldr	r0,[@@rng_state]
	mov	r1,#100
	bl	_SYM_.Random__GetValue
	add	r0,r0,r5
	cmp	r4,r0,asr #1
	movlt	r0,#0
	movge	r0,#1
	ldmia	sp!,{r4-r6,pc}
	.skip 84
@@rng_state:
.close
