.3ds
.open "code.bin","out.bin",0x100000
.include "ident.s"

.org _SYM_.map__battle__detail__RandomCalculateHit
	stmdb	sp!,{r4-r6,lr}
	mov	r6,#20
	mov	r5,#0
	mul	r4,r0,r6

@@loop:
	ldr	r0,[@@rng_state]
	mov	r1,#100
	bl	_SYM_.Random__GetValue
	subs	r6,r6,#1
	add	r5,r5,r0
	bge	@@loop

	cmp	r5,r4
	movlt	r0,#1
	movge	r0,#0
	ldmia	sp!,{r4-r6,pc}
	.skip _SYM_.map__battle__detail__RandomCalculateHit + 140 - .
@@rng_state:
.close
