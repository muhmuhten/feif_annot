.3ds
.open "code.bin","out.bin",0x100000
.include "ident.s"

.org _SYM_.Unit__GetWeaponExp
	add	r2,r0,r1
	stmdb	sp!,{r4,lr}
	ldrb	r2,[r2,#232]
	sub	sp,sp,#8
	mov	r4,sp
	str	r2,[sp,#0]
	bl	_SYM_.Unit__GetWeaponExpLimit
	ldr	r2,[sp,#0]
	add	r1,sp,#4
	str	r0,[sp,#4]
	cmp	r0,r2
	movlt	r4,r1
	ldr	r0,[r4,#0]
	add	sp,sp,#8
	ldmia	sp!,{r4,pc}
.close
