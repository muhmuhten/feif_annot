.3ds
.open "code.bin","out.bin",0x100000
.include "ident.s"

.org _SYM_.map__battle__detail__RandomCalculateHit
	stmdb	sp!,{r4,lr}
	mov	r4,r0
	ldr	r0,[@@rng_state]
	mov	r1,#100
	bl	_SYM_.Random__GetValue
	cmp	r0,r4
	movlt	r0,#1
	movge	r0,#0
	ldmia	sp!,{r4,pc}
	.skip _SYM_.map__battle__detail__RandomCalculateHit + 140 - .
@@rng_state:
.close
