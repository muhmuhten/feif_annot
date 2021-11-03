.3ds
.open "code.bin","out.bin",0x100000
.include "ident.s"

.org _SYM_.Unit__GetWeaponExp
	stmdb	sp!,{r0-r1,lr}
	bl	_SYM_.Unit__GetWeaponExpLimit
	ldmia	sp!,{r1-r2}
	add	r1,r1,#0xe8
	ldrb	r2,[r1,r2]
	ldrsb	r3,[r1,#0x47]
	add	r3,r3,r3,asr #1
	adds	r1,r2,r3
	movle	r1,#1
	cmp	r0,r1
	movgt	r0,r1
	ldmia	sp!,{pc}

.org _SYM_.Unit__CanItemEquip + 0x52d290 - 0x52cac0
	bl	_SYM_.Unit__GetWeaponExp
	b	_SYM_.Unit__CanItemEquip + 0x52d358 - 0x52cac0

.close
